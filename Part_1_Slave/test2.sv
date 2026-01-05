function void write_only_post_rand();
    if (~rst_n) begin
        mosi_arr[10:8]=3'b000;
    end else begin
        pass
    end
endfunction