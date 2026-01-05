
package SPI_wrapper_env_pkg;
import uvm_pkg::*;
import SPI_wrapper_driver_pkg::*;
import SPI_wrapper_agent_pkg::*;
import SPI_wrapper_score_pkg::*;
`include "uvm_macros.svh"

class SPI_wrapper_env extends uvm_env;
  `uvm_component_utils(SPI_wrapper_env)
  
  SPI_wrapper_agent agt;
  SPI_wrapper_score sb;
  
  function new(string name = "SPI_wrapper_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = SPI_wrapper_agent::type_id::create("agt", this);
    sb  = SPI_wrapper_score::type_id::create("sb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.agent_aport.connect(sb.sb_export);
  endfunction
endclass
endpackage