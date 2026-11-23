import uvm_pkg::*;
`include "uvm_macros.svh"
`include "counter_if.svh"

class counter_coverage extends uvm_component;
    `uvm_component_utils(counter_coverage)

    virtual counter_if vif;

    covergroup counter_cg with function sample(
        bit nRST,
        bit clear,
        bit count_enable,
        bit [3:0] overflow_val,
        bit overflow_flag
    );

        cp_reset: coverpoint nRST {
            bins reset_active   = {0};
            bins reset_inactive = {1};
        }

        cp_clear: coverpoint clear {
            bins clear_off = {0};
            bins clear_on  = {1};
        }

        cp_enable: coverpoint count_enable {
            bins disabled = {0};
            bins enabled  = {1};
        }

        cp_overflow_flag: coverpoint overflow_flag {
            bins no_overflow = {0};
            bins overflow    = {1};
        }

        cp_overflow_val: coverpoint overflow_val {
            bins low  = {[1:5]};
            bins mid  = {[6:10]};
            bins high = {[11:15]};
        }

        clear_x_enable: cross cp_clear, cp_enable;

    endgroup

    function new(string name, uvm_component parent = null);
        super.new(name, parent);

        // Embedded covergroup MUST be constructed here
        counter_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual counter_if)::get(
            this, "", "counter_vif", vif)) begin
            `uvm_fatal(
                "Coverage",
                "No virtual interface specified for coverage component"
            )
        end
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            #1ns;

            counter_cg.sample(
                vif.nRST,
                vif.clear,
                vif.count_enable,
                vif.overflow_val,
                vif.overflow_flag
            );
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "Coverage",
            $sformatf(
                "Counter functional coverage = %.2f%%",
                counter_cg.get_inst_coverage()
            ),
            UVM_LOW
        )
    endfunction

endclass