package SPI_wrapper_test_pkg;
import SPI_wrapper_env_pkg::*;
import SPI_wrapper_config_pkg::*;

import spi_slave_config_obj_pkg::*;
import spi_slave_environment_pkg::*;

import ram_enviroment_pkg::*;
import ram_config_obj_pkg::*;

import SPI_wrapper_rst_seq_pkg::*;
import SPI_wrapper_read_only_seq_pkg::*;
import SPI_wrapper_write_only_seq_pkg::*;
import SPI_wrapper_read_write_seq_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"


class SPI_wrapper_test extends uvm_test;
  `uvm_component_utils(SPI_wrapper_test)

  SPI_wrapper_env wrapper_env;
  SPI_wrapper_config SPI_wrapper_cfg_; 

  ram_enviroment ram_env;
  ram_config_obj cfg_ram;

  spi_slave_config_obj cfg_obj_test;
  spi_slave_environment slave_env;

  SPI_wrapper_rst_seq reset_seq;
  SPI_wrapper_read_only_seq read_seq;
  SPI_wrapper_write_only_seq write_seq;
  SPI_wrapper_read_write_seq read_write_seq;
  
  function new(string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction

  // Build the enviornment in the build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    wrapper_env = SPI_wrapper_env::type_id::create("wrapper_env",this);
    SPI_wrapper_cfg_ = SPI_wrapper_config::type_id::create("SPI_wrapper_cfg_",this);

    ram_env = ram_enviroment::type_id::create("ram_env",this);
		cfg_ram = ram_config_obj::type_id::create("cfg_ram");

    slave_env  =spi_slave_environment::type_id::create("slave_env",this);
    cfg_obj_test=spi_slave_config_obj::type_id::create("cfg_obj_test");

    reset_seq             = SPI_wrapper_rst_seq::type_id::create("reset_seq",this);
    read_seq        = SPI_wrapper_read_only_seq::type_id::create("read_seq",this);
    write_seq      = SPI_wrapper_write_only_seq::type_id::create("write_seq",this);
    read_write_seq = SPI_wrapper_read_write_seq::type_id::create("read_write_seq",this);

    if(!uvm_config_db #(virtual SPI_wrapper_if)::get(this,"","WRAPPER_IF",SPI_wrapper_cfg_.SPI_wrapper_vif))
      `uvm_fatal("build_phase","unable to get the interface");
    uvm_config_db #(SPI_wrapper_config)::set(this,"wrapper_env.*","WRAPPER_CFG",SPI_wrapper_cfg_);
    SPI_wrapper_cfg_.is_active = UVM_ACTIVE;

    if(!uvm_config_db#(virtual RAM_if)::get(this, "", "RAM_IF", cfg_ram.ram_cfg_vif))
      `uvm_fatal("build_phase","Unable to get the ram virtual interface - test");
    uvm_config_db#(ram_config_obj)::set(this, "ram_env.*", "RAM_CFG", cfg_ram);
    cfg_ram.is_active = UVM_PASSIVE;

    if(!uvm_config_db#(virtual spi_slave_if)::get(this,"","SLAVE_IF",cfg_obj_test.config_vif))
      `uvm_fatal("build_phase","Test-Unable to get the virtual interface");
    uvm_config_db #(spi_slave_config_obj)::set(this,"slave_env.*","SLAVE_CFG",cfg_obj_test);
    cfg_obj_test.is_active = UVM_PASSIVE;
  endfunction



  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("run_phase", "reset_seq_on", UVM_LOW);
    reset_seq.start(wrapper_env.agt.sqr);
    `uvm_info("run_phase", "reset_seq_off", UVM_LOW);

    `uvm_info("run_phase", "write_seq_on", UVM_LOW);
    write_seq.start(wrapper_env.agt.sqr);
    `uvm_info("run_phase", "write_seq_off", UVM_LOW);

    `uvm_info("run_phase", "read_seq_on", UVM_LOW);
    read_seq.start(wrapper_env.agt.sqr);
    `uvm_info("run_phase", "read_seq_off", UVM_LOW);
    
    
    `uvm_info("run_phase", "read_write_seq_on", UVM_LOW);
    read_write_seq.start(wrapper_env.agt.sqr);
    `uvm_info("run_phase", "read_write_seq_off", UVM_LOW);
    
    phase.drop_objection(this);
  endtask
endclass: SPI_wrapper_test
endpackage