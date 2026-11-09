import uvm_pkg::*;
`include "uvm_macros.svh"
`include "environment.svh"

// test creates the environment and starts the ranodmized counter sequence
class test extends uvm_test;
    `uvm_component_utils(test)

    environment env;
    virtual counter_if vif;
    counter_sequence seq;

    function new(string name = "test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // create the environment and pass the virtual interface to the agent
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = environment::type_id::create("env", this);
        seq = counter_sequence::type_id::create("seq");

        // get virtual interface from tb_counter
        if (!uvm_config_db#(virtual counter_if)::get(
            this, "", "counter_vif", vif)) begin
        `uvm_fatal("Test", "No virtual interface specified for this test instance")
        end

        // send interface down to agent components
        uvm_config_db#(virtual counter_if)::set(this, "env.agt*", "counter_vif", vif);

    endfunction: build_phase

    // start the randomized counter sequence
    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        `uvm_info("Test", "Starting Randomized Counter test", UVM_LOW)

        seq.start(env.agt.sqr);

        @(negedge vif.clk);

        phase.drop_objection(this);

    endtask: run_phase

endclass: test