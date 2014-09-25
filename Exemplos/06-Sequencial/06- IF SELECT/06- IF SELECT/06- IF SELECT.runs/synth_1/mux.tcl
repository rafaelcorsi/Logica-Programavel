# 
# Synthesis run script generated by Vivado
# 

  set_param gui.test TreeTableDev
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
set_msg_config  -id {Synth 8-2778}  -suppress 
set_msg_config  -id {Common 17-69}  -string {{ERROR: [Common 17-69] Command failed: Synthesis failed - please see the console or run log file for details}}  -suppress 
set_msg_config  -id {Common 17-55}  -string {{CRITICAL WARNING: [Common 17-55] 'set_property' expects at least one object. [/home/rafa/Dropbox/Aulas/Pos/2014/LogicaProgramavel/05-Concorrente/project_1/project_1.srcs/constrs_1/new/Nexys4_Master.xdc:3]}}  -suppress 
create_project -in_memory -part xc7a100tcsg324-1
set_property target_language VHDL [current_project]
set_param project.compositeFile.enableAutoGeneration 0
set_property default_lib xil_defaultlib [current_project]
read_vhdl -library xil_defaultlib /home/rafa/project_2/project_2.srcs/sources_1/alu.vhd
read_xdc /home/rafa/project_2/project_2.srcs/constrs_1/new/Nexys4_Master.xdc
set_property used_in_implementation false [get_files /home/rafa/project_2/project_2.srcs/constrs_1/new/Nexys4_Master.xdc]

set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/rafa/project_2/project_2.cache/wt [current_project]
set_property parent.project_dir /home/rafa/project_2 [current_project]
catch { write_hwdef -file mux.hwdef }
synth_design -top mux -part xc7a100tcsg324-1 -flatten_hierarchy none -directive RuntimeOptimized -fsm_extraction off
write_checkpoint mux.dcp
report_utilization -file mux_utilization_synth.rpt -pb mux_utilization_synth.pb