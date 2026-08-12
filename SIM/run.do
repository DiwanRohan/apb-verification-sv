# =========================================================
# APB VERIFICATION TB DO FILE
# =========================================================

# -------------------------
# USER CONFIGURATION
# -------------------------
set TESTNAME APB_RAND_TEST
set SEED random

# -------------------------
# CREATE LIBRARY
# -------------------------
vlib work
vmap work work

# -------------------------
# COMPILE
# -------------------------
vlog -sv +acc -cover bcst \
+incdir+../ENV \
+incdir+../TEST \
+incdir+../TOP \
../RTL/*.sv \
../TEST/apb_pkg.sv \
../TOP/apb_tb_top.sv

# -------------------------
# START SIMULATION
# -------------------------
vsim -coverage \
-voptargs=+acc \
-assertdebug \
-msgmode both \
-sv_seed $SEED \
work.apb_tb_top \
+$TESTNAME

# -------------------------
# ADD WAVES
# -------------------------
add wave -r /*
#do wave.do

# -------------------------
# OPTIONAL RADIX
# -------------------------
radix hex

# -------------------------
# SAVE COVERAGE ON EXIT
# -------------------------
coverage save -onexit apb_cov.ucdb

# -------------------------
# RUN SIMULATION
# -------------------------
run -all

# -------------------------
# HTML COVERAGE REPORT
# -------------------------
vcover report \
-html apb_cov.ucdb \
-htmldir cov_html

# -------------------------
# OPEN COVERAGE GUI
# -------------------------
vsim -viewcov apb_cov.ucdb

# =========================================================
# USAGE
# =========================================================
# vsim -do run.do
#
# OR
#
# questa -do run.do
#
# Change:
#   set TESTNAME WR_RD_TEST
#   set SEED 25
#
# as needed
# =========================================================



