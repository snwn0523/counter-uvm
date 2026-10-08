import uvm_pkg::*;

`include "socetlib_counter.sv"
`include "counter_if.svh"
`include "test.svh"

// Top-level testbench for the counter UVM environment
module tb_counter();

    logic clk;

    // generate clock
    initial begin
        clk = 0;
        forever #10 clk = !clk;
    end

    // interface
    counter_if cnt_if(clk);

    // DUT
    socetlib_counter #(
        .NBITS(4)
    ) counter_dut (
        .CLK(cnt_if.clk),
        .nRST(cnt_if.nRST),
        .clear(cnt_if.clear),
        .count_enable(cnt_if.count_enable),
        .overflow_val(cnt_if.overflow_val),
        .count_out(cnt_if.count_out),
        .overflow_flag(cnt_if.overflow_flag)
    );

    // pass the interface to UVM and start the test
    initial begin
        uvm_config_db#(virtual counter_if)::set(null, "", "counter_vif", cnt_if);

        run_test("test");
    end

endmodule