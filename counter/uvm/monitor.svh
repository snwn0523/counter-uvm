import uvm_pkg::*;
`include "uvm_macros.svh"
`include "counter_if.svh"

// monitor observes DUT signals and sends results to the scoreboard
class monitor extends uvm_monitor; 
    `uvm_component_utils(monitor)

    virtual counter_if vif;

    uvm_analysis_port#(transaction) result_ap;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        result_ap = new("result_ap", this);
    endfunction: new

    // get the virtual interface
    virtual function void build_phase(uvm_phase phase);

        if (!uvm_config_db#(virtual counter_if)::get(
            this, "", "counter_vif", vif)) begin
            `uvm_fatal("Monitor", "No virtual interface specified for this monitor instance")
        end

    endfunction

    // sample DUT inputs and outputs every clock cycle
    virtual task run_phase(uvm_phase phase);

        forever begin
            transaction tx;

            // sample after the DUT updates at the positive clock edge
            @(negedge vif.clk);

            if (vif.nRST == 1'b1) begin

                tx = transaction#(4)::type_id::create("tx");

                tx.clear = vif.clear;
                tx.count_enable = vif.count_enable;
                tx.overflow_val = vif.overflow_val;

                tx.count_out = vif.count_out;
                tx.overflow_flag = vif.overflow_flag;

                result_ap.write(tx);
            end
        end

    endtask: run_phase

endclass: monitor