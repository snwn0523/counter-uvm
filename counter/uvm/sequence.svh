import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.svh"

// sequence that generates stimulus for the counter DUT
class counter_sequence extends uvm_sequence#(transaction);
    `uvm_object_utils(counter_sequence)

    function new(string name = "");
        super.new(name);
    endfunction: new

    task body();
        transaction req_item;

        // create a transaction object
        req_item = transaction#(4)::type_id::create("req_item");

        // basic counting test: count for 10 cycles
        repeat(10) begin
        start_item(req_item);

        req_item.clear = 0;
        req_item.count_enable = 1;
        req_item.overflow_val = 4'd15;

        finish_item(req_item);
        end
    endtask: body

endclass: counter_sequence

// sequencer passes transactions from the sequence to the driver
class sequencer extends uvm_sequencer#(transaction);
    `uvm_component_utils(sequencer)

    function new(input string name = "sequencer",
                uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

endclass: sequencer