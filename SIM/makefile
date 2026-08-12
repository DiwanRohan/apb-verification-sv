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
TEST ?= APB_SANITY_TEST
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
	vsim -coverage -sv_seed $(SEED) -c $(TOP_MODULE) +$(TEST) -do "coverage save -onexit $(COV_DB); run -all; quit -f"

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

sanity:
	$(MAKE) run TEST=APB_SANITY_TEST

regress:
	$(MAKE) run TEST=APB_SANITY_TEST COV_DB=cov_sanity.ucdb
	$(MAKE) run TEST=APB_RAND_TEST COV_DB=cov_rand.ucdb
	$(MAKE) run TEST=APB_BOUNDARY_TEST COV_DB=cov_boundary.ucdb
	$(MAKE) run TEST=APB_TRANSITION_TEST COV_DB=cov_transition.ucdb
	$(MAKE) run TEST=APB_WR_RD_SAME_TEST COV_DB=cov_wr_rd_same.ucdb
	$(MAKE) run TEST=APB_COV_TEST COV_DB=cov_cov.ucdb
	$(MAKE) run TEST=APB_RESET_TEST COV_DB=cov_reset.ucdb
	$(MAKE) run TEST=APB_ERROR_TEST COV_DB=cov_error.ucdb
	vcover merge $(COV_DB) cov_sanity.ucdb cov_rand.ucdb cov_boundary.ucdb cov_transition.ucdb cov_wr_rd_same.ucdb cov_cov.ucdb cov_reset.ucdb cov_error.ucdb
