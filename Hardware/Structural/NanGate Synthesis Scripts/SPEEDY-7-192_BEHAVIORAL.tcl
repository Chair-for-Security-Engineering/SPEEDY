# Setting Environment
cd my_designs/SPEEDY-7-192_45nm/Structural
## Clean Workspace
if [file exists WORK] {file delete -force WORK}
## Define Design Lib
file mkdir WORK
define_design_lib WORK -path "./WORK"



# Setting Libraries
set search_path "../../../LIBS/NanGate_45nm"
set target_library "NangateopenCellLibrary_typical.db"
set link_library [concat * $target_library]
set alib_library_analysis_path "../../../LIBS/ALIB/"



# Loading Design
analyze -library WORK -autoread "./"



# Elaborating Design (synthesis into generic logic cells)
elaborate -library WORK SPEEDY_Top -arch "Behavioral"



# Cell Constraints (keep SB and MC representation intact)
set_size_only -all_instances [get_flat_cells SPEEDY_instance/SB*/*] true
set_size_only -all_instances [get_flat_cells SPEEDY_instance/MC*/*] true



# Timing Constraints
## Clock (Set clk period to a value that can never be achieved)
create_clock -period 0.0000001 -name my_clock [get_ports clk]
## Area
set_max_area 1000000



# Miscellaneous
## Flatten
ungroup -flatten [get_cells SPEEDY_instance/*]
## Preventing Multi-output ports
set_fix_multiple_port_nets -all -buffer_constants



# Compiling Design (mapping into logic cells of logic library + optimization to meet the constraints)
compile_ultra -no_autoungroup
## Remove Cell Constraints for Incremental Compile (allow any kind of optimization from here)
set_size_only -all_instances [get_flat_cells SPEEDY_instance/SB*/*] false
set_size_only -all_instances [get_flat_cells SPEEDY_instance/MC*/*] false
## Incremental Compile (repeat incremental compiles to keep the optimization incentive alive)
compile_ultra -incremental -no_autoungroup
compile_ultra -incremental -no_autoungroup
compile_ultra -incremental -no_autoungroup



# Uniquify
uniquify -force



# Writing Synthesized Design
file mkdir Netlist_45nm
write -format verilog -hierarchy -output "Netlist_45nm/SPEEDY-7-192.v"
change_names -rules vhdl -hier
write -format vhdl -hierarchy -output "Netlist_45nm/SPEEDY-7-192.vhd"



# Reporting
file mkdir Report_45nm
report_timing -significant_digits 13 > "Report_45nm/SPEEDY-7-192.tim.rpt"
report_area -hierarchy > "Report_45nm/SPEEDY-7-192.area.rpt"
create_clock -period 10.0 -name my_clock [get_ports clk]
report_power -analysis_effort high -verbose > "Report_45nm/SPEEDY-7-192.power.rpt"



# Removing Current Design 
remove_design -all
# Setting Environment
cd ../../SPEEDY-7-192_15nm/Structural
## Clean Workspace
if [file exists WORK] {file delete -force WORK}
## Define Design Lib
file mkdir WORK
define_design_lib WORK -path "./WORK"



# Setting Libraries
set search_path "../../../LIBS/NanGate_15nm"
set target_library "NanGate_15nm_OCL_typical_conditional_ccs.db"
set link_library [concat * $target_library]
set alib_library_analysis_path "../../../LIBS/ALIB/"



# Loading Design
analyze -library WORK -rebuild -autoread "./"



# Elaborating Design (synthesis into generic logic cells)
elaborate -library WORK SPEEDY_Top -arch "Behavioral"



# Cell Constraints (keep SB and MC representation intact)
set_size_only -all_instances [get_flat_cells SPEEDY_instance/SB*/*] true
set_size_only -all_instances [get_flat_cells SPEEDY_instance/MC*/*] true



# Timing Constraints
## Clock (Set clk period to a value that can never be achieved)
create_clock -period 0.0000001 -name my_clock [get_ports clk]
## Area
set_max_area 1000000



# Miscellaneous
## Flatten
ungroup -flatten [get_cells SPEEDY_instance/*]
## Preventing Multi-output ports
set_fix_multiple_port_nets -all -buffer_constants



# Compiling Design (mapping into logic cells of logic library + optimization to meet the constraints)
compile_ultra -no_autoungroup
## Remove Cell Constraints for Incremental Compile (allow any kind of optimization from here)
set_size_only -all_instances [get_flat_cells SPEEDY_instance/SB*/*] false
set_size_only -all_instances [get_flat_cells SPEEDY_instance/MC*/*] false
## Incremental Compile (repeat incremental compiles to keep the optimization incentive alive)
compile_ultra -incremental -no_autoungroup
compile_ultra -incremental -no_autoungroup
compile_ultra -incremental -no_autoungroup



# Uniquify
uniquify -force



# Writing Synthesized Design
file mkdir Netlist_15nm
write -format verilog -hierarchy -output "Netlist_15nm/SPEEDY-7-192.v"
change_names -rules vhdl -hier
write -format vhdl -hierarchy -output "Netlist_15nm/SPEEDY-7-192.vhd"



# Reporting
file mkdir Report_15nm
report_timing -significant_digits 13 > "Report_15nm/SPEEDY-7-192.tim.rpt"
report_area -hierarchy > "Report_15nm/SPEEDY-7-192.area.rpt"
create_clock -period 10000.0 -name my_clock [get_ports clk]
report_power -analysis_effort high -verbose > "Report_15nm/SPEEDY-7-192.power.rpt"