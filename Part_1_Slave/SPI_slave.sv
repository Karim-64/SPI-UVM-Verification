module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (received_address) 
                        ns = READ_DATA;  // edit_1 replacing READ_ADD with READ_DATA
                    else
                        ns = READ_ADD;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
        default : ns = IDLE;
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0;
        counter <= 0; // edit_2 Counter should be 0 when the rst_n is asserted
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                counter <= counter - 1;
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                end
                rx_valid <= (counter ==0 )? 1 : 0; //EDIT
            end
            READ_ADD : begin
                counter <= counter - 1;
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                end
                else begin
                    received_address <= 1;
                end
                rx_valid <= (counter ==0 )? 1 : 0; //EDIT            
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                    end
                end
                else begin
                    // edit_3 when the counter is set to 8  
                    // the rx_data continues reading again. 
                    // Adding the condition of NOT rx_valid 
                    // will fix it    
                    if(counter > 0 && ~rx_valid) begin                  
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 8;
                    end
                end
            end
            default : begin
            end
        endcase
    end
end

/********************************************************************************************************/
`ifdef SIM
    property p_idle_chk_trans;
        @(posedge clk) disable iff (~rst_n) ((!$stable(cs)) && $past(cs)==IDLE) |-> (cs==CHK_CMD);
    endproperty
    assert property (p_idle_chk_trans);
    cover property (p_idle_chk_trans);
    
    property chk_to_states_trans;
        @(posedge clk) disable iff (~rst_n) ( (!$stable(cs)) && (cs==READ_ADD || cs==WRITE || cs==READ_DATA)) 
        |-> ($past(cs)==CHK_CMD);
    endproperty
    assert property (chk_to_states_trans);
    cover property (chk_to_states_trans);
    
    
    property p_to_idle_trans;
        @(posedge clk) disable iff (~rst_n) ((!$stable(cs)) && ($past(cs)==WRITE || $past(cs)==READ_ADD 
        || $past(cs)==READ_DATA)) |-> (cs==IDLE);
    endproperty
    assert property (p_to_idle_trans);
    cover property (p_to_idle_trans);
    
`endif
/********************************************************************************************************/


endmodule