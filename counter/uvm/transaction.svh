`ifndef TRANSACTION_SVH
`define TRANSACTION_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

// transaction object that carries counter inputs and observed outputs
class transaction #(parameter NUM_BITS = 4) extends uvm_sequence_item;

    // input fields driven to the DUT
    rand bit nRST;
    rand bit clear;
    rand bit count_enable;
    rand bit [NUM_BITS-1:0] overflow_val;
    // output fields observed from the DUT
    bit [NUM_BITS-1:0] count_out;
    bit overflow_flag;

    // constraints for random stimulus
    constraint counter_constraints {
        nRST dist {1 := 95, 0 := 5};
        clear dist {0 := 90, 1 := 10};
        count_enable dist {1 := 80, 0:= 20};
        overflow_val inside {[1:(2**NUM_BITS)-1]};
    }

    // register transaction fields with the UVM factory
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(nRST, UVM_NOCOMPARE)
        `uvm_field_int(clear, UVM_NOCOMPARE)
        `uvm_field_int(count_enable, UVM_NOCOMPARE)
        `uvm_field_int(overflow_val, UVM_NOCOMPARE)

        `uvm_field_int(count_out, UVM_DEFAULT)
        `uvm_field_int(overflow_flag, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "transaction");
        super.new(name);
    endfunction: new

endclass: transaction

`endif