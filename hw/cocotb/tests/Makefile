TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)

export PYTHONPATH := $(PWD)/../model:$(PYTHONPATH)

ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES += $(PWD)/../../rtl/acc.sv
    VERILOG_SOURCES += $(PWD)/../../rtl/sha256_module.sv
    VERILOG_SOURCES += $(PWD)/../../rtl/sha256_incl.svh
else ifeq ($(TOPLEVEL_LANG),vhdl)
    VHDL_SOURCES = $(PWD)/../../rtl/*.vhdl
else
    $(error A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

TOPLEVEL := sha256
MODULE   := test_sha256

include $(shell cocotb-config --makefiles)/Makefile.sim
