#!/bin/bash -f
# Vivado (TM) v2015.3 (64-bit)
#
# Filename    : uc_GPIO.sh
# Simulator   : Synopsys Verilog Compiler Simulator
# Description : Simulation script for compiling, elaborating and verifying the project source files.
#               The script will automatically create the design libraries sub-directories in the run
#               directory, add the library logical mappings in the simulator setup file, create default
#               'do' file, copy glbl.v into the run directory for verilog sources in the design (if any),
#               execute compilation, elaboration and simulation steps.
#
# Generated by Vivado on Mon Nov 23 13:17:12 BRST 2015
# IP Build 1367837 on Mon Sep 28 08:56:14 MDT 2015 
#
# usage: uc_GPIO.sh [-help]
# usage: uc_GPIO.sh [-lib_map_path]
# usage: uc_GPIO.sh [-noclean_files]
# usage: uc_GPIO.sh [-reset_run]
#
# Prerequisite:- To compile and run simulation, you must compile the Xilinx simulation libraries using the
# 'compile_simlib' TCL command. For more information about this command, run 'compile_simlib -help' in the
# Vivado Tcl Shell. Once the libraries have been compiled successfully, specify the -lib_map_path switch
# that points to these libraries and rerun export_simulation. For more information about this switch please
# type 'export_simulation -help' in the Tcl shell.
#
# You can also point to the simulation libraries by either replacing the <SPECIFY_COMPILED_LIB_PATH> in this
# script with the compiled library directory path or specify this path with the '-lib_map_path' switch when
# executing this script. Please type 'uc_GPIO.sh -help' for more information.
#
# Additional references - 'Xilinx Vivado Design Suite User Guide:Logic simulation (UG900)'
#
# ********************************************************************************************************

# Script info
echo -e "uc_GPIO.sh - Script generated by export_simulation (Vivado v2015.3 (64-bit)-id)\n"

# Script usage
usage()
{
  msg="Usage: uc_GPIO.sh [-help]\n\
Usage: uc_GPIO.sh [-lib_map_path]\n\
Usage: uc_GPIO.sh [-reset_run]\n\
Usage: uc_GPIO.sh [-noclean_files]\n\n\
[-help] -- Print help information for this script\n\n\
[-lib_map_path <path>] -- Compiled simulation library directory path. The simulation library is compiled\n\
using the compile_simlib tcl command. Please see 'compile_simlib -help' for more information.\n\n\
[-reset_run] -- Recreate simulator setup files and library mappings for a clean run. The generated files\n\
from the previous run will be removed. If you don't want to remove the simulator generated files, use the\n\
-noclean_files switch.\n\n\
[-noclean_files] -- Reset previous run, but do not remove simulator generated files from the previous run.\n\n"
  echo -e $msg
  exit 1
}

if [[ ($# == 1 ) && ($1 != "-lib_map_path" && $1 != "-noclean_files" && $1 != "-reset_run" && $1 != "-help" && $1 != "-h") ]]; then
  echo -e "ERROR: Unknown option specified '$1' (type \"./uc_GPIO.sh -help\" for more information)\n"
  exit 1
fi

if [[ ($1 == "-help" || $1 == "-h") ]]; then
  usage
fi

# STEP: setup
setup()
{
  case $1 in
    "-lib_map_path" )
      if [[ ($2 == "") ]]; then
        echo -e "ERROR: Simulation library directory path not specified (type \"./uc_GPIO.sh -help\" for more information)\n"
        exit 1
      fi
      # precompiled simulation library directory path
     create_lib_mappings $2
     copy_glbl_file
    ;;
    "-reset_run" )
      reset_run
      echo -e "INFO: Simulation run files deleted.\n"
      exit 0
    ;;
    "-noclean_files" )
      # do not remove previous data
    ;;
    * )
     create_lib_mappings $2
     copy_glbl_file
  esac

  # Add any setup/initialization commands here:-

  # <user specific commands>

}

# Copy glbl.v file into run directory
copy_glbl_file()
{
  glbl_file="glbl.v"
  src_file="/home/Dados/opt/Xilinx/Vivado/2015.3/data/verilog/src/glbl.v"
  if [[ ! -e $glbl_file ]]; then
    cp $src_file .
  fi
}

# Remove generated data from the previous run and re-create setup files/library mappings
reset_run()
{
  files_to_remove=(ucli.key uc_GPIO_simv vlogan.log vhdlan.log compile.log elaborate.log simulate.log .vlogansetup.env .vlogansetup.args .vcs_lib_lock scirocco_command.log 64 AN.DB csrc uc_GPIO_simv.daidir)
  for (( i=0; i<${#files_to_remove[*]}; i++ )); do
    file="${files_to_remove[i]}"
    if [[ -e $file ]]; then
      rm -rf $file
    fi
  done
}

# Main steps
run()
{
  setup $1 $2
  compile
  elaborate
  simulate
}

# Create design library directory paths and define design library mappings in cds.lib
create_lib_mappings()
{
  libs=(microblaze_v9_5_2 xil_defaultlib lmb_v10_v3_0_7 lmb_bram_if_cntlr_v4_0_7 blk_mem_gen_v8_3_0 axi_lite_ipif_v3_0_3 mdm_v3_2_4 lib_cdc_v1_0_2 proc_sys_reset_v5_0_8 interrupt_control_v3_1_2 axi_gpio_v2_0_8 generic_baseblocks_v2_1_0 axi_infrastructure_v1_1_0 axi_register_slice_v2_1_6 fifo_generator_v13_0_0 axi_data_fifo_v2_1_5 axi_crossbar_v2_1_7)
  file="synopsys_sim.setup"
  dir="vcs"

  if [[ -e $file ]]; then
    rm -f $file
  fi

  if [[ -e $dir ]]; then
    rm -rf $dir
  fi

  touch $file
  lib_map_path="<SPECIFY_COMPILED_LIB_PATH>"
  if [[ ($1 != "" && -e $1) ]]; then
    lib_map_path="$1"
  else
    echo -e "ERROR: Compiled simulation library directory path not specified or does not exist (type "./top.sh -help" for more information)\n"
  fi
  incl_ref="OTHERS=$lib_map_path/synopsys_sim.setup"
  echo $incl_ref >> $file

  for (( i=0; i<${#libs[*]}; i++ )); do
    lib="${libs[i]}"
    lib_dir="$dir/$lib"
    if [[ ! -e $lib_dir ]]; then
      mkdir -p $lib_dir
      mapping="$lib : $dir/$lib"
      echo $mapping >> $file
    fi
  done
}


# RUN_STEP: <compile>
compile()
{
  # Directory path for design sources and include directories (if any) wrt this path
  ref_dir="."
  # Command line options
  opts_ver="-full64 -timescale=1ps/1ps"
  opts_vhd="-full64"

  # Compile design files
  vhdlan -work microblaze_v9_5_2 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/microblaze_v9_5/hdl/microblaze_v9_5_vh_rfs.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work xil_defaultlib $opts_vhd \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_microblaze_0_0/sim/uc_GPIO_microblaze_0_0.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work lmb_v10_v3_0_7 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_v10_v3_0/hdl/vhdl/lmb_v10.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work xil_defaultlib $opts_vhd \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_dlmb_v10_0/sim/uc_GPIO_dlmb_v10_0.vhd" \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_ilmb_v10_0/sim/uc_GPIO_ilmb_v10_0.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work lmb_bram_if_cntlr_v4_0_7 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/lmb_bram_if_funcs.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/lmb_bram_if_primitives.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/xor18.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/parity.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/parityenable.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/checkbit_handler.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/correct_one_bit.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/pselect.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/pselect_mask.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/axi_interface.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/lmb_mux.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lmb_bram_if_cntlr_v4_0/hdl/vhdl/lmb_bram_if_cntlr.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work xil_defaultlib $opts_vhd \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_dlmb_bram_if_cntlr_0/sim/uc_GPIO_dlmb_bram_if_cntlr_0.vhd" \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_ilmb_bram_if_cntlr_0/sim/uc_GPIO_ilmb_bram_if_cntlr_0.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work blk_mem_gen_v8_3_0 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/blk_mem_gen_v8_3/simulation/blk_mem_gen_v8_3.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work xil_defaultlib $opts_vhd \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_lmb_bram_0/sim/uc_GPIO_lmb_bram_0.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work axi_lite_ipif_v3_0_3 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/ipif_pkg.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/pselect_f.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/address_decoder.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/slave_attachment.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/axi_lite_ipif.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work mdm_v3_2_4 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/mdm_v3_2/hdl/vhdl/mdm_primitives.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/mdm_v3_2/hdl/vhdl/arbiter.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/mdm_v3_2/hdl/vhdl/srl_fifo.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/mdm_v3_2/hdl/vhdl/bus_master.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/mdm_v3_2/hdl/vhdl/jtag_control.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/mdm_v3_2/hdl/vhdl/mdm_core.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/mdm_v3_2/hdl/vhdl/mdm.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work xil_defaultlib $opts_vhd \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_mdm_1_0/sim/uc_GPIO_mdm_1_0.vhd" \
  2>&1 | tee -a vhdlan.log

  vlogan -work xil_defaultlib $opts_ver +v2k +incdir+"$ref_dir/../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"$ref_dir/../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_clk_wiz_1_0/uc_GPIO_clk_wiz_1_0_clk_wiz.v" \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_clk_wiz_1_0/uc_GPIO_clk_wiz_1_0.v" \
  2>&1 | tee -a vlogan.log

  vhdlan -work lib_cdc_v1_0_2 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/lib_cdc_v1_0/hdl/src/vhdl/cdc_sync.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work proc_sys_reset_v5_0_8 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/proc_sys_reset_v5_0/hdl/src/vhdl/upcnt_n.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/proc_sys_reset_v5_0/hdl/src/vhdl/sequence_psr.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/proc_sys_reset_v5_0/hdl/src/vhdl/lpf.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/proc_sys_reset_v5_0/hdl/src/vhdl/proc_sys_reset.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work xil_defaultlib $opts_vhd \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_rst_clk_wiz_1_100M_0/sim/uc_GPIO_rst_clk_wiz_1_100M_0.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work interrupt_control_v3_1_2 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/interrupt_control_v3_1/hdl/src/vhdl/interrupt_control.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work axi_gpio_v2_0_8 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_gpio_v2_0/hdl/src/vhdl/gpio_core.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_gpio_v2_0/hdl/src/vhdl/axi_gpio.vhd" \
  2>&1 | tee -a vhdlan.log

  vhdlan -work xil_defaultlib $opts_vhd \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_axi_gpio_0_1/sim/uc_GPIO_axi_gpio_0_1.vhd" \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_axi_gpio_0_2/sim/uc_GPIO_axi_gpio_0_2.vhd" \
  2>&1 | tee -a vhdlan.log

  vlogan -work generic_baseblocks_v2_1_0 $opts_ver +v2k +incdir+"$ref_dir/../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"$ref_dir/../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry_and.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry_latch_and.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry_latch_or.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry_or.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_command_fifo.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_mask_static.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_mask.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_sel_mask_static.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_sel_mask.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_sel_static.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_sel.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_static.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_mux_enc.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_mux.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_nto1_mux.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work axi_infrastructure_v1_1_0 $opts_ver +v2k +incdir+"$ref_dir/../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"$ref_dir/../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog/axi_infrastructure_v1_1_axi2vector.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog/axi_infrastructure_v1_1_axic_srl_fifo.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog/axi_infrastructure_v1_1_vector2axi.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work axi_register_slice_v2_1_6 $opts_ver +v2k +incdir+"$ref_dir/../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"$ref_dir/../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_register_slice_v2_1/hdl/verilog/axi_register_slice_v2_1_axic_register_slice.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_register_slice_v2_1/hdl/verilog/axi_register_slice_v2_1_axi_register_slice.v" \
  2>&1 | tee -a vlogan.log

  vhdlan -work fifo_generator_v13_0_0 $opts_vhd \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/fifo_generator_v13_0/simulation/fifo_generator_vhdl_beh.vhd" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/fifo_generator_v13_0/hdl/fifo_generator_v13_0_rfs.vhd" \
  2>&1 | tee -a vhdlan.log

  vlogan -work axi_data_fifo_v2_1_5 $opts_ver +v2k +incdir+"$ref_dir/../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"$ref_dir/../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_axic_fifo.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_fifo_gen.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_axic_srl_fifo.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_axic_reg_srl_fifo.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_ndeep_srl.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_axi_data_fifo.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work axi_crossbar_v2_1_7 $opts_ver +v2k +incdir+"$ref_dir/../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"$ref_dir/../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_addr_arbiter_sasd.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_addr_arbiter.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_addr_decoder.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_arbiter_resp.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_crossbar_sasd.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_crossbar.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_decerr_slave.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_si_transactor.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_splitter.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_wdata_mux.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_wdata_router.v" \
    "$ref_dir/./../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_axi_crossbar.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work xil_defaultlib $opts_ver +v2k +incdir+"$ref_dir/../../../../uc.srcs/sources_1/bd/uc_GPIO/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"$ref_dir/../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" \
    "$ref_dir/./../../../bd/uc_GPIO/ip/uc_GPIO_xbar_0/sim/uc_GPIO_xbar_0.v" \
  2>&1 | tee -a vlogan.log

  vhdlan -work xil_defaultlib $opts_vhd \
    "$ref_dir/./../../../bd/uc_GPIO/hdl/uc_GPIO.vhd" \
  2>&1 | tee -a vhdlan.log


  vlogan -work xil_defaultlib $opts_ver +v2k \
    ./glbl.v \
  2>&1 | tee -a vlogan.log

}

# RUN_STEP: <elaborate>
elaborate()
{
  opts="-full64 -debug_pp -t ps -licqueue -l elaborate.log"

  vcs $opts xil_defaultlib.uc_GPIO xil_defaultlib.glbl -o uc_GPIO_simv
}

# RUN_STEP: <simulate>
simulate()
{
  opts="-ucli -licqueue -l simulate.log"

  ./uc_GPIO_simv $opts -do simulate.do
}
# Script usage
usage()
{
  msg="Usage: uc_GPIO.sh [-help]\n\
Usage: uc_GPIO.sh [-lib_map_path]\n\
Usage: uc_GPIO.sh [-reset_run]\n\
Usage: uc_GPIO.sh [-noclean_files]\n\n\
[-help] -- Print help information for this script\n\n\
[-lib_map_path <path>] -- Compiled simulation library directory path. The simulation library is compiled\n\
using the compile_simlib tcl command. Please see 'compile_simlib -help' for more information.\n\n\
[-reset_run] -- Recreate simulator setup files and library mappings for a clean run. The generated files\n\
from the previous run will be removed. If you don't want to remove the simulator generated files, use the\n\
-noclean_files switch.\n\n\
[-noclean_files] -- Reset previous run, but do not remove simulator generated files from the previous run.\n\n"
  echo -e $msg
  exit 1
}


# Launch script
run $1 $2
