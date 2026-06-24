# ===== DIRECTORIES =====
RTL_DIR  = ../RTL
ENV_DIR  = ../ENV
TEST_DIR = ../TEST
TOP_DIR  = ../TOP

# ===== FILES =====
RTL = $(RTL_DIR)/apb_slave.sv
PKG = $(TEST_DIR)/apb_pkg.sv
ASSERTIONS = $(ENV_DIR)/apb_assertions.sv
TOP = $(TOP_DIR)/apb_tb_top.sv
# ===== TOP MODULE =====
TOP_MODULE = apb_tb_top

# ===== TEST SELECTION =====
TEST ?= APB_RAND_TEST
SEED ?= random

# ===== COVERAGE FILE =====
COV_DB = apb_cov.ucdb

# ===== DEFAULT =====
all: run

# ===== LIBRARY =====
lib:
	vlib work

# ===== COMPILE =====
comp: lib
	vlog -sv +acc -cover bcst \
	+incdir+../ENV \
	+incdir+../TEST \
	+incdir+../TOP \
	$(RTL) $(PKG) $(ASSERTIONS) $(TOP)

# ===== RUN (CLI) =====
run: comp
	vsim -coverage -sv_seed $(SEED) -c $(TOP_MODULE) +$(TEST) -do "run -all; coverage save -onexit $(COV_DB); quit -f"

# ===== RUN GUI =====
gui: comp
	vsim -coverage -sv_seed $(SEED) $(TOP_MODULE) +$(TEST)

# ===== COVERAGE REPORT =====
cov:
	vcover report -details $(COV_DB)

# ===== HTML COVERAGE REPORT =====
cov_html:
	vcover report \
	-html $(COV_DB) \
	-htmldir cov_html

# ===== OPEN HTML REPORT =====
open_cov:
	firefox cov_html/index.html &

# ===== COVERAGE GUI =====
cov_gui:
	vsim -viewcov $(COV_DB)

# ===== CLEAN =====
clean:
	rm -rf work transcript vsim.wlf *.ucdb

regress:
	make run TEST=APB_DIRECTED_TEST
	make run TEST=APB_RAND_TEST SEED=1
	make run TEST=APB_RAND_TEST SEED=2
	make run TEST=APB_RAND_TEST SEED=3
