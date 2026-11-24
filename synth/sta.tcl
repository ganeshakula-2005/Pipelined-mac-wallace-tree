# 1. Read library and netlist
read_liberty /home/ganesh/eda/opensta/test/nangate45/Nangate45_typ.lib
read_verilog mac_synth.v
link_design mac

# 2. Read constraints
read_sdc constraints.sdc

# 3. Setup (Max Delay) Analysis - Critical Path
puts "\n=============================================="
puts "       SETUP TIMING REPORT (CRITICAL PATH)    "
puts "==============================================\n"
report_checks -path_delay max -fields {slew cap input fanout} -digits 3

# 4. Hold (Min Delay) Analysis - Race Conditions
puts "\n=============================================="
puts "                 HOLD TIMING REPORT           "
puts "==============================================\n"
report_checks -path_delay min -fields {slew cap input fanout} -digits 3

# 5. Summary of Slacks
puts "\n=============================================="
puts "                 SLACK SUMMARY                "
puts "==============================================\n"
report_worst_slack -max
report_worst_slack -min
report_tns

exit
