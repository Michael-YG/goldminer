onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /simple_sha256_tb/tb_0_result
add wave -noupdate /simple_sha256_tb/clk
add wave -noupdate /simple_sha256_tb/reset
add wave -noupdate /simple_sha256_tb/hashdone
add wave -noupdate /simple_sha256_tb/chipselect
add wave -noupdate /simple_sha256_tb/write
add wave -noupdate /simple_sha256_tb/read
add wave -noupdate /simple_sha256_tb/address
add wave -noupdate /simple_sha256_tb/writedata
add wave -noupdate /simple_sha256_tb/bitcoin_input
add wave -noupdate /simple_sha256_tb/test_input
add wave -noupdate /simple_sha256_tb/bitcoin_output
add wave -noupdate /simple_sha256_tb/test_output
add wave -noupdate /simple_sha256_tb/data_out
add wave -noupdate /simple_sha256_tb/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
