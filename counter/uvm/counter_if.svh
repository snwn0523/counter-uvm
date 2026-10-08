`ifndef COUNTER_IF_SVH
`define COUNTER_IF_SVH

// interface connecting the UVM testbench and the Counter DUT
interface counter_if #(parameter NBITS = 4) (input logic clk);
    
    // counter input signals
    logic nRST;
    logic clear;
    logic count_enable;
    logic [NBITS-1:0] overflow_val;
    // counter output signals
    logic [NBITS-1:0] count_out;
    logic overflow_flag;

    // signal directions from the tb/uvm side
    modport tester (
        input  count_out, overflow_flag, clk,
        output nRST, clear, count_enable, overflow_val
    );

    // signal directions from the DUT side
    modport counter (
        output count_out, overflow_flag,
        input  nRST, clear, count_enable, overflow_val, clk
    );

endinterface

`endif