package SPI_wrapper_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_wrapper_sqr_pkg::*;
    import SPI_wrapper_seq_item_pkg::*;
    import SPI_wrapper_driver_pkg::*; 
    import SPI_wrapper_monitor_pkg::*; 
    import SPI_wrapper_config_pkg::*; 

    class SPI_wrapper_agent extends uvm_agent;   
        `uvm_component_utils(SPI_wrapper_agent)
        SPI_wrapper_sqr sqr;
        SPI_wrapper_driver drv;
        SPI_wrapper_monitor mon;
        SPI_wrapper_config SPI_wrapper_cfg;
        uvm_analysis_port #(SPI_wrapper_seq_item) agent_aport;
        
        function new(string name = "SPI_wrapper_agent", uvm_component parent = null);
           super.new(name, parent); 
        endfunction 

        function void  build_phase(uvm_phase phase);
            super.build_phase(phase);
            uvm_config_db #(SPI_wrapper_config) :: get(this, "", "WRAPPER_CFG", SPI_wrapper_cfg);

            if(SPI_wrapper_cfg.is_active == UVM_ACTIVE) begin
                drv = SPI_wrapper_driver::type_id::create("drv", this);
                sqr = SPI_wrapper_sqr::type_id::create("sqr", this);
            end 
            mon = SPI_wrapper_monitor::type_id::create("mon", this);
            agent_aport = new("agent_port", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if(SPI_wrapper_cfg.is_active == UVM_ACTIVE) begin
                drv.wrapper_vif = SPI_wrapper_cfg.SPI_wrapper_vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end
            
            mon.SPI_wrapper_vif = SPI_wrapper_cfg.SPI_wrapper_vif;
            mon.mon_aport.connect(agent_aport);
        endfunction
    endclass 
endpackage