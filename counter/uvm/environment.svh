import uvm_pkg::*;
`include "uvm_macros.svh"
`include "agent.svh"
`include "scoreboard.svh"

// environment contains and connects the main UVM components
class environment extends uvm_env;
    `uvm_component_utils(environment)

    agent agt;
    scoreboard sb;

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // create the agent and scoreboard
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt = agent::type_id::create("agt", this);
        sb  = scoreboard::type_id::create("sb", this);
    endfunction

    // connect the monitor output to the scoreboard
    function void connect_phase(uvm_phase phase);
        agt.mon.result_ap.connect(sb.analysis_export);
    endfunction

endclass: environment