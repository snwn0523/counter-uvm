import uvm_pkg::*;
`include "uvm_macros.svh"
`include "counter_if.svh"

// driver converts transactions into actual DUR signals
class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)

    virtual counter_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // get the virtual interface from the UVM configuration database
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // get interface
        if (!uvm_config_db#(virtual counter_if)::get(
            this, "", "counter_vif", vif)) begin
        `uvm_fatal("Driver", "No virtual interface specified for this test instance");
        end
    endfunction: build_phase

    // receive transactions from the sequencer and drive DUT inputs
    task run_phase(uvm_phase phase);
        transaction req_item;

        //Inital values
        vif.nRST = 1'b1;
        vif.clear = 1'b0;
        vif.count_enable = 1'b0;
        vif.overflow_val = '0;

        forever begin
            seq_item_port.get_next_item(req_item);

            @(negedge vif.clk);

            // drive basic counting inputs
            vif.nRST = req_item.nRST;
            vif.clear = req_item.clear;
            vif.count_enable = req_item.count_enable;
            vif.overflow_val = req_item.overflow_val;

            @(posedge vif.clk);

            seq_item_port.item_done();
        end
    endtask: run_phase

endclass: driver