package spi_slave_seq_item_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"

    class spi_slave_seq_item extends uvm_sequence_item;
        `uvm_object_utils(spi_slave_seq_item)
        
        rand bit   rst_n, SS_n, tx_valid;
        bit MOSI;
        rand bit  [7:0] tx_data;
        logic  [9:0] rx_data;
        logic  rx_valid, MISO;
        logic  rx_valid_exp, MISO_exp;
        logic  [9:0] rx_data_exp;
        int cycles_counter=0;
        int mosi_index=10;
        int max_cnt;
        bit transaction_ended=0;
        bit [2:0] prev_op;


        rand bit [10:0] mosi_arr;

        function new (string name="spi_slave_seq_item");
            super.new(name);
            transaction_ended=0;
            wr_or_rd_data.constraint_mode(0);
        endfunction

        function string convert2string();
            return $sformatf ("%sreset=%b|SS_n=%b|MOSI=%b|tx_valid=%b|tx_data=%b|
            rx_data=%b|rx_data_exp=%b|rx_valid=%b|rx_valid_exp=%b|MISO=%b|MISO_exp=%b"
            ,super.convert2string,rst_n,SS_n,MOSI,tx_valid,tx_data,rx_data,rx_data_exp,rx_valid,rx_valid_exp,MISO,MISO_exp);   
        endfunction

        function string convert2string_stimulus();
            return $sformatf ("%sreset=%b|SS_n=%b|MOSI=%b|tx_valid=%b|tx_data=%b"
            ,super.convert2string,rst_n,SS_n,MOSI,tx_valid,tx_data);   
        endfunction

        function void post_randomize();
            if (~rst_n) begin
                transaction_ended=0;
                cycles_counter=0;
                mosi_index=10;
                mosi_arr[10:8]=0;
                wr_or_rd_data.constraint_mode(0);
                wr_or_rd_add.constraint_mode(1);
                mosi_arr.rand_mode(1);
            end else begin
                if(mosi_arr[10:8]==3'b111) begin
                    max_cnt=23;
                    tx_data.rand_mode(0);
                end else begin
                    max_cnt=13;
                    tx_data.rand_mode(1);
                end

              if(~SS_n)
                cycles_counter++;

                if (cycles_counter==max_cnt) begin
                    transaction_ended=1;
                    cycles_counter=0;
                    mosi_arr.rand_mode(1);

                    if (prev_op==3'b110) begin
                        wr_or_rd_add.constraint_mode(0);
                        wr_or_rd_data.constraint_mode(1);

                    end else if (prev_op==3'b111)begin
                        wr_or_rd_data.constraint_mode(0);
                        wr_or_rd_add.constraint_mode(1);
                    end
                    mosi_index=10;


                end 
                else begin
                    transaction_ended=0;
                    prev_op=mosi_arr[10:8];
                    mosi_arr.rand_mode(0); 
                end

                if(mosi_index>=0 && cycles_counter>=2 )begin
                       MOSI = mosi_arr[mosi_index];
                       mosi_index--;
                end
            end

            
        endfunction

        //SLAVE_1
        constraint rst_con {
           rst_n dist {0:=2, 1:=98};
        }

        //SLAVE_2,SLAVE_3,SLAVE_4
        constraint wr_or_rd_add {
             mosi_arr[10:8] inside {3'b000, 3'b001, 3'b110};
        }

        //SLAVE_2,SLAVE_3,SLAVE_5
        constraint wr_or_rd_data {
            mosi_arr[10:8] inside {3'b000, 3'b001, 3'b111};
        }



        //SLAVE_6
        constraint tx_read_data_con { if (mosi_arr[10:8]==3'b111 && cycles_counter>=13) 
                                            tx_valid==1;
                                        else 
                                            tx_valid==0;}

        //SLAVE_7
        constraint ss_n_con { if (transaction_ended==1)
                                SS_n==1;
                              else
                                SS_n==0;
        }


    endclass

endpackage