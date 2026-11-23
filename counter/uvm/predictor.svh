import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.svh"

class predictor extends uvm_component;
    `uvm_component_utils(predictor)

    uvm_analysis_imp#(transaction, predictor) analysis_export;
    uvm_analysis_port#(transaction) predicted_ap;

    bit [3:0] expected_count;
    bit expected_overflow;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);

        expected_count = 0;
        expected_overflow = 0;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_export = new("analusis_export", this);
        predicted_ap = new("predicted_ap", this);
    endfunction

    function void write(transaction tx);
        transaction predicted_tx;

        predicted_tx = transaction#(4)::type_id::create("predicted_tx");

        // preserve monitored inputs and actual DUT outputs
        predicted_tx.copy(tx);

        // reference model
        if (!tx.nRST) begin
            expected_count = 0;
            expected_overflow = 0;
        end
        else begin
            // clear has priority over count_enable
            if (tx.clear) begin
                expected_count = 0;
            end
            else if (tx.count_enable) begin
                if ((int'(expected_count) + 1) > int'(tx.overflow_val)) begin
                    expected_count = 1;
                end
                else begin
                    expected_count = expected_count + 1;
                end
            end

            expected_overflow = (expected_count == tx.overflow_val);
        end

        predicted_tx.expected_count = expected_count;
        predicted_tx.expected_overflow = expected_overflow;

        predicted_ap.write(predicted_tx);
    endfunction
endclass