import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.svh"

// scoreboard checks the DUT count against the expected count
class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp#(transaction, scoreboard) analysis_export;

    bit [3:0] expected_count;
    int m_matches;
    int m_mismatches;

    function new(string name, uvm_component parent);
        super.new(name, parent);

        expected_count = 0;
        m_matches = 0;
        m_mismatches = 0;
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_export = new("analysis_export", this);
    endfunction: build_phase

    // compare the expected count with the DUT output
    function void write(transaction tx);

        // basic counting test only
        if (tx.count_enable && !tx.clear)
        expected_count = expected_count + 1;

        if (tx.count_out == expected_count) begin

        m_matches++;

        `uvm_info(
            "Scoreboard",
            $sformatf(
            "PASS: expected count = %0d, actual count = %0d",
            expected_count,
            tx.count_out
            ),
            UVM_LOW
        )
        end
        else begin

        m_mismatches++;

        `uvm_error(
            "Scoreboard",
            $sformatf(
            "FAIL: expected count = %0d, actual count = %0d",
            expected_count,
            tx.count_out
            )
        )
        end

    endfunction: write

    function void report_phase(uvm_phase phase);
        `uvm_info(
        "Scoreboard",
        $sformatf(
            "Matches: %0d, Mismatches: %0d",
            m_matches,
            m_mismatches
        ),
        UVM_LOW
        )
    endfunction: report_phase

endclass: scoreboard