import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.svh"

// sequence that generates stimulus for the counter DUT
class counter_sequence extends uvm_sequence#(transaction);
    `uvm_object_utils(counter_sequence)

    function new(string name = "");
        super.new(name);
    endfunction: new

    int num_transaction = 25;

    task body();
        transaction req_item;

        repeat(num_transaction) begin
            req_item = transaction#(4)::type_id::create("req_item");

            start_item(req_item);

            if (!req_item.randomize()) begin
                `uvm_fatal("Sequence", "Randomization failed")
            end

            `uvm_info("Sequence",
                $sformatf(
                    "nRST=%0b clear=%0b enable=%0b overflow_val=%0d",
                    req_item.nRST,
                    req_item.clear,
                    req_item.count_enable,
                    req_item.overflow_val
                ),
                UVM_LOW)

            finish_item(req_item);
        end

        // Directed transaction to close clear_on x disabled coverage bin
        req_item = transaction#(4)::type_id::create("directed_clear_disabled");
        start_item(req_item);

        req_item.nRST        = 1'b1;
        req_item.clear       = 1'b1;
        req_item.count_enable = 1'b0;
        req_item.overflow_val = 4'd15;

        `uvm_info("Sequence",
            $sformatf(
                "Directed: nRST=%0b clear=%0b enable=%0b overflow_val=%0d",
                req_item.nRST,
                req_item.clear,
                req_item.count_enable,
                req_item.overflow_val
            ),
            UVM_LOW)

        finish_item(req_item);


        `uvm_info(
            "Sequence",
            $sformatf(
                "Generated %0d randomized transactions",
                num_transaction
            ),
            UVM_LOW
        )
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