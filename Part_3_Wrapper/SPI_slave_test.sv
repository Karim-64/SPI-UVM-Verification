package spi_slave_test_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import spi_slave_config_obj_pkg::*;
    import spi_slave_environment_pkg::*;
    import spi_slave_main_seq_pkg::*;
    import spi_slave_reset_seq_pkg::*;

    class spi_slave_test extends uvm_test;
        `uvm_component_utils(spi_slave_test)
        spi_slave_config_obj cfg_obj_test;
        spi_slave_environment env;
        spi_slave_reset_seq rst_seq;
        spi_slave_main_seq main_seq;

        function new (string name="spi_slave_test",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cfg_obj_test=spi_slave_config_obj::type_id::create("cfg_obj_test");
            if(!uvm_config_db#(virtual spi_slave_if)::get(this,"","SLAVE_IF",cfg_obj_test.config_vif))
                `uvm_fatal("build_phase","Test-Unable to get the virtual interface");
            uvm_config_db #(spi_slave_config_obj)::set(this,"*","CFG",cfg_obj_test);
            env=spi_slave_environment::type_id::create("env",this);
            rst_seq=spi_slave_reset_seq::type_id::create("rst_seq");
            main_seq=spi_slave_main_seq::type_id::create("main_seq");
           
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            rst_seq.start(env.agt.sqr);
            main_seq.start(env.agt.sqr);
            phase.drop_objection(this);
        endtask

    endclass
   
endpackage