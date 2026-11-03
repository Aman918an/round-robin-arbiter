export DESIGN_NAME=round_robin_arbiter
export PLATFORM=nangate45

export VERILOG_FILES=$(DESIGN_HOME)/src/round_robin_arbiter.v
export SDC_FILE=$(DESIGN_HOME)/asic/constraints/arbiter.sdc

export ABC_AREA=1
export CORE_UTILIZATION=55
export PLACE_DENSITYLB_ADDON=0.20
export TNS_END_PERCENT=100
export GPL_PLACE_IOS=1
export SYNTH_REPEATABLE_BUILD=1

export PDN_TCL=$(DESIGN_HOME)/asic/pdn/grid_strategy.tcl
