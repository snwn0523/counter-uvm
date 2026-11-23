# Variables
TBTOP=tb_counter

# Name of UVM test to be run
TESTNAME=test
VERBOSITY=UVM_MEDIUM

# Ensure QUESTA_HOME is set to the QuestaSim installation directory
QUESTA_HOME?=/package/eda/mg/questa10.6b/questasim

# Makefile Targets
all: build run_gui

build:
	@echo "Building testbench and DUT..."
	vlog +acc \
	+cover \
	+incdir+. \
	+incdir+../src \
	$(TBTOP).sv \
	-logfile tb_compile.log \
	-printinfilenames=file_search.log

RESULTS=results

run: build
	mkdir -p $(RESULTS)
	vsim -c $(TBTOP) \
	-voptargs=+acc \
	-coverage \
	-wlf $(RESULTS)/$(TESTNAME).wlf \
	-l $(RESULTS)/$(TESTNAME).log \
	+UVM_TESTNAME="$(TESTNAME)" \
	+UVM_VERBOSITY=$(VERBOSITY) \
	-do "log -r /*; coverage save -onexit $(RESULTS)/$(TESTNAME).ucdb; run -all; quit -f"

coverage:
	vcover report \
	-details \
	-codeAll \
	-cvg \
	-output $(RESULTS)/$(TESTNAME)_coverage.txt \
	$(RESULTS)/$(TESTNAME).ucdb

run_gui: build
	@echo "Running simulation in GUI mode..."
	vsim -coverage -i $(TBTOP) \
	-voptargs=+acc \
	+UVM_TESTNAME="$(TESTNAME)" \
	+UVM_VERBOSITY=$(VERBOSITY) \
	-do "do wave.do" -do "run -all" &

clean:
	@echo "Cleaning up..."
	rm -rf work
	rm -rf results
	rm -f wlf*
	rm -f transcript
	rm -f *.log
	rm -f *.vstf
	rm -f *.wlf

.PHONY: build run run_gui coverage clean all
