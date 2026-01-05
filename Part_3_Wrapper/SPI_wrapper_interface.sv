interface SPI_wrapper_if (clk);
    input bit clk;
    logic  MOSI;
    logic  SS_n;
    logic  rst_n;
    logic  MISO, MISO_ref;
endinterface 