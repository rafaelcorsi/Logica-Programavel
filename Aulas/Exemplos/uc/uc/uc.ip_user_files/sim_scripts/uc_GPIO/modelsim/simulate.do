onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L unisims_ver -L unimacro_ver -L secureip -L microblaze_v9_5_2 -L xil_defaultlib -L lmb_v10_v3_0_7 -L lmb_bram_if_cntlr_v4_0_7 -L blk_mem_gen_v8_3_0 -L axi_lite_ipif_v3_0_3 -L mdm_v3_2_4 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_8 -L interrupt_control_v3_1_2 -L axi_gpio_v2_0_8 -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0 -L axi_register_slice_v2_1_6 -L fifo_generator_v13_0_0 -L axi_data_fifo_v2_1_5 -L axi_crossbar_v2_1_7 -lib xil_defaultlib xil_defaultlib.uc_GPIO xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {uc_GPIO.udo}

run -all

quit -force
