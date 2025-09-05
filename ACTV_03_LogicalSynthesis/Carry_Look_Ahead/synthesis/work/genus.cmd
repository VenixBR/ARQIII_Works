# Cadence Genus(TM) Synthesis Solution, Version 21.18-s082_1, built Jul 18 2023 13:08:41

# Date: Tue Sep 02 17:57:47 2025
# Host: gmicro02 (x86_64 w/Linux 4.18.0-553.37.1.el8_10.x86_64) (16cores*32cpus*2physical cpus*Intel(R) Xeon(R) Silver 4314 CPU @ 2.40GHz 16384KB)
# OS:   Red Hat Enterprise Linux release 8.10 (Ootpa)

source /home/schultz/Documents/ARQIII_Works/ACTV_03_LogicalSynthesis/Carry_Look_Ahead/synthesis/scripts/Carry_Look_Ahead.tcl
# entering suspend mode
set_db [get_db designs] .preserve true
write_hdl > netlist_gen.v
set_db [get_db designs] .dont_touch
set_db [get_db designs] .dont_touch true
set_db [get_db designs] .dont_touch true
set_db [get_db designs] .preserve true
get_db [get_db designs] .preserve
set_db [get_db designs] .preserve true
set_db [get_db designs] .preserve dont_optimize
set_db [get_db designs] .preserve -h
set_db [get_db designs] .preserve false
set_db [get_db designs] .preserve true
set_db [get_db designs] .preserve True
get_db modules
get_db insts
get_db hinsts
get_db hinsts
get_db designs
