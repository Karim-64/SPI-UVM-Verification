        constraint ss_n_con { if (transaction_ended==1)
                                SS_n==1;
                              else
                                SS_n==0;
        }

        constraint rst_con {
           rst_n dist {0:=5, 1:=95};
        }

        constraint mosi_state_wr_add {
             mosi_arr[10:8] ==3'b000;
        }

        constraint mosi_state_wr_data {
            mosi_arr[10:8] == 3'b001;
        }

        function new (string name="");
            super.new(name);
            transaction_ended=0;
            cycles_counter=0;
            mosi_index=10;
            addr_received=0; //enable and disable constraints in seq after create
        endfunction

         function void post_randomize();
            if (~rst_n) begin
                transaction_ended=0;
                cycles_counter=0;
                mosi_index=10;
                addr_received=0;
                /***TO BE DONE IN SEPARATE FUNCTION*****/

                //mosi_arr[10:8]=0;
                //mosi_state_con2.constraint_mode(0);
                //mosi_state_con1.constraint_mode(1);
                //mosi_arr.rand_mode(1);
            end else begin
                if(mosi_arr[10:8]==3'b111) begin
                    max_cnt=23;
                end else begin
                    max_cnt=13;
                end

              if(~SS_n)
                cycles_counter++;

                if (cycles_counter==max_cnt) begin
                    transaction_ended=1;
                    cycles_counter=0;
                    mosi_arr.rand_mode(1);

                    // if (prev_mode==3'b000) begin
                    //     mosi_state_con1.constraint_mode(0);
                    //     mosi_state_con2.constraint_mode(1);

                    // end else if (prev_mode==3'b001)begin
                    //     mosi_state_con2.constraint_mode(0);
                    //     mosi_state_con1.constraint_mode(1);
                    // end
                    mosi_index=10;


                end 
                else begin
                    transaction_ended=0;
                    prev_mode=mosi_arr[10:8];
                    mosi_arr.rand_mode(0); 
                end

                if(mosi_index>=0 && cycles_counter>=2 )begin
                       MOSI = mosi_arr[mosi_index];
                       mosi_index--;
                end
            end

            
        endfunction
       

