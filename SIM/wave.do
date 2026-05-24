onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /apb_tb_top/DUT/pclk
add wave -noupdate /apb_tb_top/DUT/psel
add wave -noupdate /apb_tb_top/DUT/prstn
add wave -noupdate /apb_tb_top/DUT/penable
add wave -noupdate /apb_tb_top/DUT/pready
add wave -noupdate /apb_tb_top/DUT/paddr
add wave -noupdate /apb_tb_top/DUT/pwdata
add wave -noupdate /apb_tb_top/DUT/prdata
add wave -noupdate /apb_tb_top/DUT/pwrite
add wave -noupdate /apb_tb_top/DUT/pslverr
add wave -noupdate /apb_tb_top/DUT/wait_cnt
add wave -noupdate /apb_pkg::reset_start_ev
add wave -noupdate /apb_pkg::reset_done_ev
add wave -noupdate /apb_pkg::drv_done
add wave -noupdate /apb_pkg::mon_done
add wave -noupdate /apb_pkg::raise_ctr
add wave -noupdate /apb_pkg::reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 214
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {121 ns}
