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
        
        // 1.1 Reset Behavior
        repeat(2) begin
            start_item(req_item);
            req_item.nRST = 0;
            req_item.clear = 0;
            req_item.count_enable = 0;
            req_item.overflow_val = 4'd15;
            finish_item(req_item);
        end

        // Release reset
        start_item(req_item);
        req_item.nRST = 1;
        req_item.clear = 0;
        req_item.count_enable = 0;
        req_item.overflow_val = 4'd15;
        finish_item(req_item);

        // 2.1 Basic Counting
        repeat(5) begin
            start_item(req_item);
            req_item.nRST = 1;
            req_item.clear = 0;
            req_item.count_enable = 1;
            req_item.overflow_val = 4'd15;
            finish_item(req_item);
        end

        // 2.2 Count Hold
        repeat(3) begin
            start_item(req_item);
            req_item.nRST = 1;
            req_item.clear = 0;
            req_item.count_enable = 0;
            req_item.overflow_val = 4'd15;
            finish_item(req_item);
        end

        // 3.1 Synchronus Clear
            start_item(req_item);
            req_item.nRST = 1;
            req_item.clear = 1;
            req_item.count_enable = 0;
            req_item.overflow_val = 4'd15;
            finish_item(req_item);

        // Verify clear output on the following cycle
            start_item(req_item);
            req_item.nRST = 1;
            req_item.clear = 0;
            req_item.count_enable = 0;
            req_item.overflow_val = 4'd15;
            finish_item(req_item);
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