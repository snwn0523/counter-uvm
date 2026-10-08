import uvm_pkg::*;
`include "uvm_macros.svh"
`include "sequence.svh"
`include "driver.svh"
`include "monitor.svh"

// agent groups the sequencer, driver and monitor
class agent extends uvm_agent;
    `uvm_component_utils(agent)

    sequencer sqr;
    driver drv;
    monitor mon;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // create agent components
    virtual function void build_phase(uvm_phase phase);
        sqr = sequencer::type_id::create("sqr", this);
        drv = driver::type_id::create("drv", this);
        mon = monitor::type_id::create("mon", this);
    endfunction

    // connect the sequencer to the driver
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction

endclass: agent