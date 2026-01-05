package SPI_wrapper_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    typedef enum int {
        WRITE_ONLY = 0,
        READ_ONLY = 1,
        WRITE_READ = 2
    } spi_mode_e;


    class SPI_wrapper_seq_item extends uvm_sequence_item; 
        `uvm_object_utils(SPI_wrapper_seq_item)
        
        bit  MOSI;
        rand logic  SS_n;
        rand bit  rst_n;
        logic MISO_ref;

        bit [2:0] prev_op;
        bit transaction_ended = 0;

        logic  MISO;
        int    counter=0;
        int    max_cnt;
        int mosi_index=10;
        rand bit [10:0] mosi_arr;
        spi_mode_e mode;

        constraint rst_n_const
        {
            rst_n dist {1:/98 ,0:/2}; 
        }

        constraint SS_n_const
        {
            if(transaction_ended)
                SS_n == 1;
            else
                SS_n == 0; 
        }     

        // WRAPPER_1
        constraint wr_add { mosi_arr[10:8]==3'b000; }  
        constraint wr_add_or_data { mosi_arr[10:8] inside {3'b000,3'b001 }; }

        // WRAPPER_2
        constraint rd_add { mosi_arr[10:8]==3'b110; }  
        constraint rd_data { mosi_arr[10:8]==3'b111; }  

        // WRAPPER_3
        constraint wr_data_add {mosi_arr[10:8] dist {3'b110:/60, 3'b000:/40}; }
        constraint rd_data_add {mosi_arr[10:8] dist {3'b110:/40, 3'b000:/60}; }

    static function SPI_wrapper_seq_item create_item(string name= "SPI_wrapper_seq_item", spi_mode_e mode);
        SPI_wrapper_seq_item item;
        item = SPI_wrapper_seq_item::type_id::create(name);
        item.mode = mode;
        
        if (mode == WRITE_ONLY) begin
            item.rd_data.constraint_mode(0);
            item.rd_add.constraint_mode(0);
            item.wr_add_or_data.constraint_mode(0);
            item.wr_add.constraint_mode(1);
            item.wr_data_add.constraint_mode(0);
            item.rd_data_add.constraint_mode(0);

        end else if (mode == READ_ONLY) begin
            item.wr_add_or_data.constraint_mode(0);
            item.wr_add.constraint_mode(0);
            item.rd_data.constraint_mode(0);
            item.rd_add.constraint_mode(1);
            item.wr_data_add.constraint_mode(0);
            item.rd_data_add.constraint_mode(0);

        end else if (mode==WRITE_READ) begin
            item.rd_data.constraint_mode(0);
            item.rd_add.constraint_mode(0);
            item.wr_add_or_data.constraint_mode(0);
            item.wr_add.constraint_mode(1);
            item.wr_data_add.constraint_mode(0);
            item.rd_data_add.constraint_mode(0);

        end
        
        return item;
    endfunction

        function void post_randomize();
            if (~rst_n) begin
                transaction_ended=1;
                counter=0;
                mosi_index=10;
                if(mode==WRITE_ONLY)begin
                    mosi_arr[10:8]=0;

                    rd_data.constraint_mode(0);
                    rd_add.constraint_mode(0);

                    wr_add_or_data.constraint_mode(0);
                    wr_add.constraint_mode(1);
                    wr_data_add.constraint_mode(0);
                    rd_data_add.constraint_mode(0);

                end else if (mode==READ_ONLY) begin
                    mosi_arr[10:8]=3'b110;

                    rd_data.constraint_mode(0);
                    rd_add.constraint_mode(1);

                    wr_add_or_data.constraint_mode(0);
                    wr_add.constraint_mode(0);

                    wr_data_add.constraint_mode(0);
                    rd_data_add.constraint_mode(0);


                end else if (mode==WRITE_READ) begin
                   mosi_arr[10:8]=0;

                    rd_data.constraint_mode(0);
                    rd_add.constraint_mode(0);

                    wr_add_or_data.constraint_mode(0);
                    wr_add.constraint_mode(1);

                    wr_data_add.constraint_mode(0);
                    rd_data_add.constraint_mode(0);
  
                end

                mosi_arr.rand_mode(1);
            end else begin
                if(mosi_arr[10:8]==3'b111) begin
                    max_cnt=23;
                end else begin
                    max_cnt=13;
                end

              if(~SS_n)
                counter++;

                if (counter==max_cnt) begin
                    transaction_ended=1;
                    counter=0;
                    mosi_arr.rand_mode(1);
                    if(mode==WRITE_ONLY || mode==READ_ONLY)begin
                        if (prev_op==3'b000) begin //write_add
                            wr_add_or_data.constraint_mode(1);
                            wr_add.constraint_mode(0);

                        end else if (prev_op==3'b001)begin //write_data
                            wr_add_or_data.constraint_mode(0);
                            wr_add.constraint_mode(1);
                        end else if (prev_op==3'b110) begin //read_add
                            rd_data.constraint_mode(1);
                            rd_add.constraint_mode(0);

                        end else if (prev_op==3'b111)begin //read_data
                            rd_data.constraint_mode(0);
                            rd_add.constraint_mode(1);
                        end

                    end else if (mode==WRITE_READ) begin
                        if (prev_op==3'b000) begin //write_add
                            rd_data.constraint_mode(0);

                            wr_add_or_data.constraint_mode(1); //write_add_or_write_data

                            wr_data_add.constraint_mode(0);
                            rd_data_add.constraint_mode(0);
                            wr_add.constraint_mode(0);
                            rd_add.constraint_mode(0);

                        end else if(prev_op==3'b001) begin //write_data
                            rd_data.constraint_mode(0);

                            wr_add_or_data.constraint_mode(0);

                            rd_data_add.constraint_mode(0);
                            wr_add.constraint_mode(0);
                            rd_add.constraint_mode(0);
                            wr_data_add.constraint_mode(1);


                           
                        end else if (prev_op==3'b110) begin

                            wr_add_or_data.constraint_mode(0);

                            wr_data_add.constraint_mode(0);
                            rd_data_add.constraint_mode(0);
                            wr_add.constraint_mode(0);
                            rd_add.constraint_mode(0);
                            rd_data.constraint_mode(1);


                           
                        end else if (prev_op==3'b111) begin
                            rd_data.constraint_mode(0);
                            wr_add.constraint_mode(0);

                            wr_add_or_data.constraint_mode(0);

                            wr_data_add.constraint_mode(0);
                            rd_add.constraint_mode(0);
                            rd_data_add.constraint_mode(1);     
                        end
                    end

                    mosi_index=10;


                end 
                else begin
                    transaction_ended=0;
                    prev_op=mosi_arr[10:8];
                    mosi_arr.rand_mode(0); 
                end

                if(mosi_index>=0 && counter>=2 )begin
                       MOSI = mosi_arr[mosi_index];
                       mosi_index--;
                end
            end
        endfunction


        function string convert2string();
            return $sformatf(
                "%s mode = %s | MOSI = 0b%b | SS_n = 0b%b | rst_n = 0b%b | MISO = 0b%b",
                super.convert2string(), mosi_arr[10:8], MOSI, SS_n, rst_n, MISO
            );
        endfunction

        function string convert2string_stimulus();
            return $sformatf("mode = %s | MOSI = 0b%b | SS_n = 0b%b | rst_n = 0b%b | MISO = 0b%b",
                mosi_arr[10:8], MOSI, SS_n, rst_n, MISO
            );
        endfunction
    endclass    
endpackage