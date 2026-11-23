import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.svh"

// scoreboard checks the DUT count against the expected count
class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp#(transaction, scoreboard) analysis_export;

    int cycle_checks;
    int m_matches;
    int mismatches;

    int reset_checks;
    int clear_checks;
    int hold_checks;
    int count_checks;
    // int rollover_checks;

    function new(string name, uvm_component parent);
        super.new(name, parent);

        cycle_checks = 0;
        m_matches = 0;
        mismatches = 0;

        reset_checks = 0;
        clear_checks = 0;
        hold_checks = 0;
        count_checks = 0;
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_export = new("analysis_export", this);
    endfunction: build_phase

    // compare the expected count with the DUT output
    function void write(transaction tx);

        cycle_checks++;

        // track what functionality was checked
        if (!tx.nRST)
            reset_checks++;
        else if (tx.clear)
            clear_checks++;
        else if (!tx.count_enable)
            hold_checks++;
        else
            count_checks++;

        // // rollover condition
        // if (tx.nRST && !tx.clear && tx.count_enable && (tx.expected_count == 1) && (tx.count_out == 1))
        //     rollover_checks++;
        
        // compare predictor result against DUT result
        if ((tx.count_out == tx.expected_count) && (tx.overflow_flag == tx.expected_overflow)) begin

            m_matches++;

            `uvm_info(
                "Scoreboard",
                $sformatf(
                "PASS: count expected=%0d actual=%0d | overflow expected=%0b actual=%0b",
                tx.expected_count,
                tx.count_out,
                tx.expected_overflow,
                tx.overflow_flag
                ),
                UVM_LOW
            )
        end
        else begin

            mismatches++;

            `uvm_error(
                "Scoreboard",
                $sformatf(
                "FAIL: count expected=%0d actual=%0d | overflow expected=%0b actual=%0b",
                tx.expected_count,
                tx.count_out,
                tx.expected_overflow,
                tx.overflow_flag
                )
            )
        end
        
    endfunction: write

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
        "Scoreboard",
        $sformatf(
            {"Cycle Checks=%0d Matches=%0d Mismatches=%0d | ", "Reset=%0d Clear=%0d Hold=%0d Count=%0d"},
            cycle_checks,
            m_matches,
            mismatches,
            reset_checks,
            clear_checks,
            hold_checks,
            count_checks
        ),
        UVM_LOW
        )
    endfunction: report_phase

endclass: scoreboard