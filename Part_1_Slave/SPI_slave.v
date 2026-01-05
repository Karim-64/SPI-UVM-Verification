module spi_slave_ref #(
    parameter IDLE      = 3'b000, // 0
    parameter WRITE     = 3'b001, // 1
    parameter CHK_CMD   = 3'b010, // 2
    parameter READ_ADD  = 3'b011, // 3 
    parameter READ_DATA = 3'b100  // 4
) (
    input            MOSI,      // data sent from the master to the slave
    input            SS_n,      // signal by the master to enable the slave
    input            clk,
    input            rst_n,
    input      [7:0] tx_data,   // for data coming from the RAM
    input            tx_valid,  // enable to store the data coming from the RAM
    output reg       MISO,      // data sent from the slave to the master
    output reg [9:0] rx_data,   // for data to be sent to the RAM
    output reg       rx_valid   // enable for the RAM to store the data on rx_data
);

    (* fsm_encoding = "gray" *)
    reg [2:0] cs, ns;   // current state and next state
    reg [5:0] counter;  // counter for serial to parallel data conversion
    reg       rd_addr;  // a signal to know if the address is received or not

    // next state logic
    always @(*) begin
        case (cs)
            IDLE:    ns = (SS_n) ? IDLE : CHK_CMD;
            CHK_CMD: begin
                if (~SS_n)
                  if (MOSI) ns = (rd_addr) ? READ_DATA : READ_ADD;
                  else ns = WRITE;
                else ns = IDLE;
            end
            WRITE:   ns = (SS_n == 1) ? IDLE : WRITE;
            READ_ADD: begin
                if (SS_n == 1) ns = IDLE;
                else ns = READ_ADD;
            end
            READ_DATA: begin
                if ( SS_n == 1) ns = IDLE;
                else ns = READ_DATA;
            end
            default: ns = IDLE;
        endcase
    end

    // current state memory and slave data handling
    always @(posedge clk) begin
        if (~rst_n) begin
            cs      <= IDLE;
            counter <= 3'b0;
            MISO    <= 0;
            rx_data <= 10'b0;
            rd_addr <= 0;
            rx_valid <= 0;
        end 
        else begin
            cs <= ns;

            // First state
            if (cs == IDLE) begin
                counter <= 0;
                rx_valid <= 0;
            end

            // Second and third states 
            else if (cs == WRITE || cs == READ_ADD) begin
                // Raising the rx_valid flag when all the data are converted parallel
                // for one cycle for the ram to capture it
                rx_valid <= (counter == 10)? 1 : 0;   

                // Converting the series data into parallel to send it to the ram
                if (counter < 10) 
                    rx_data[9-counter] <= MOSI;  
                else if (cs == READ_ADD && counter==10)
                    // Storing the info of receiving an address 
                    // to enter the READ_DATA mode the next time
                    rd_addr <= 1;  
                
                // Incrementing the counter every cycle 
                counter <= counter + 1;
            end 

            // Fourth state
            else if (cs == READ_DATA) begin
                if(~tx_valid) begin
                    // Receiving 2 bits operation bits from the master 
                    // and 8 dummy bits 
                    // total 11 clk cycles
                    if (counter < 10 && ~rx_valid) begin
                        rx_data[9-counter] <= MOSI;  
                        counter <= counter + 1;
                    end
                    else if( counter == 10) begin
                        rx_valid <= 1;
                        counter <= 0;
                    end
                end
                else begin
                    // Receiving 8 data bits from the ram
                    // total 9 clk cycles
                    rx_valid <= 0;
                    if (counter < 8)
                        MISO <= tx_data[7-counter];
                    else if (counter == 8)
                        rd_addr <= 0;
                    counter <= counter + 1;
                end
            end
        end
    end
endmodule