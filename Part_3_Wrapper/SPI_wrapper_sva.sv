module wrapper_sva(
    input  MOSI, 
    input  SS_n,
    input  clk,
    input  rst_n,
    input  MISO
);

property property_1;
    @(posedge clk) (~rst_n |-> ##2 (~MISO));
endproperty

// description: checking the that the MISO is stable always except in the case of READ_DATA == 111
property property_2;
    @(posedge clk) disable iff(~rst_n) 
    ( SS_n ##1 ~SS_n ##1 ~MOSI[*3]  |=> $stable(MISO)[->8]);
endproperty

property property_3;
    @(posedge clk) disable iff(~rst_n) 
    ( SS_n ##1 ~SS_n ##1 ~MOSI[*2] ##1 MOSI  |=> $stable(MISO)[->8]);
endproperty

property property_4;
    @(posedge clk) disable iff(~rst_n) 
    ( SS_n ##1 ~SS_n ##1 MOSI[*2] ##1 ~MOSI |=> $stable(MISO)[->8]);
endproperty

rst_prop                 :assert property(property_1);
MISO_WRITE_ADD_prop      :assert property(property_2);
MISO_WRITE_DATA_prop     :assert property(property_3);
MISO_READ_DATA_prop      :assert property(property_4);

cov_rst_prop             :cover property (property_1);
cov_MISO_WRITE_ADD_prop  :cover property (property_2);
cov_MISO_WRITE_DATA_prop :cover property (property_3);
cov_MISO_READ_DATA_prop  :cover property (property_4);
endmodule