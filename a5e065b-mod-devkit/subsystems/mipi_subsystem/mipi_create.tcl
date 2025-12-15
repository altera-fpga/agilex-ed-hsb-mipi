###################################################################################
# Copyright (C) 2025 Altera Corporation
#
# This software and the related documents are Altera copyrighted materials, and
# your use of them is governed by the express license under which they were
# provided to you ("License"). Unless the License provides otherwise, you may
# not use, modify, copy, publish, distribute, disclose or transmit this software
# or the related documents without Altera's prior written permission.
#
# This software and the related documents are provided as is, with no express
# or implied warranties, other than those that are expressly stated in the License.
###################################################################################


set_shell_parameter VID_FREQ     "156.25"
set_shell_parameter CPU_CLK_FREQ "100"

proc pre_creation_step {} {
    transfer_files
    evaluate_terp
}

proc creation_step {} {
    mipi_subsystem
}

proc post_creation_step {} {
    edit_top_level_qsys
    add_auto_connections
    edit_top_v_file
}

proc post_connection_step {} {

}

#==============================================================================

# copy files from the user non_qpds_ip install directory to the target project directory
proc transfer_files {} {

    set v_project_path      [get_shell_parameter PROJECT_PATH]
    set v_script_path       [get_shell_parameter SUBSYSTEM_SOURCE_PATH]

    file_copy   ${v_script_path}/mipi_ModKit.qsf.terp \
        ${v_project_path}/quartus/user/mipi.qsf.terp

    file_copy   ${v_script_path}/mipi_subsystem.sdc.terp \
        ${v_project_path}/sdc/user/mipi_subsystem.sdc

}

proc mipi_subsystem {} {

    set v_project_path    [get_shell_parameter PROJECT_PATH]
    set v_instance_name   [get_shell_parameter INSTANCE_NAME]

    create_system ${v_instance_name}
    save_system   ${v_project_path}/rtl/user/${v_instance_name}.qsys

    load_system   ${v_project_path}/rtl/user/${v_instance_name}.qsys

    # create instances

    add_instance mipi_vid_clk_bridge          altera_clock_bridge
    add_instance mipi_vid_rst_bridge          altera_reset_bridge

    add_instance mipi_cpu_clk_bridge          altera_clock_bridge
    add_instance mipi_cpu_rst_bridge          altera_reset_bridge

    add_instance mipi_dphy                    mipi_dphy
    add_instance mipi_pio                     altera_avalon_pio

    add_instance intel_mipi_csi2              intel_mipi_csi2
    add_instance mipi_mm_ccb                  mm_ccb

    add_instance mipi_mm_bridge               altera_avalon_mm_bridge

    #----------------------------------------------------------------

    #mipi_pio
    set_instance_parameter_value mipi_pio bitModifyingOutReg {0}
    set_instance_parameter_value mipi_pio captureEdge {0}
    set_instance_parameter_value mipi_pio direction {InOut}
    set_instance_parameter_value mipi_pio generateIRQ {0}
    set_instance_parameter_value mipi_pio resetValue {0.0}
    set_instance_parameter_value mipi_pio simDoTestBenchWiring {0}
    set_instance_parameter_value mipi_pio width {32}

    #intel_mipi_csi2
    set_instance_parameter_value intel_mipi_csi2 BITS_PER_LANE {16}
    set_instance_parameter_value intel_mipi_csi2 BUFFER_DEPTH {128}
    set_instance_parameter_value intel_mipi_csi2 DIRECTION {rx}
    set_instance_parameter_value intel_mipi_csi2 DPHY_LINE_RATE {2500}
    set_instance_parameter_value intel_mipi_csi2 ENABLE_CRC {1}
    set_instance_parameter_value intel_mipi_csi2 ENABLE_CSR {1}
    set_instance_parameter_value intel_mipi_csi2 ENABLE_ECC {1}
    set_instance_parameter_value intel_mipi_csi2 ENABLE_ED_FILESET_SIM {0}
    set_instance_parameter_value intel_mipi_csi2 ENABLE_ED_FILESET_SYNTHESIS {1}
    set_instance_parameter_value intel_mipi_csi2 ENABLE_SCRAMBLING {0}
    set_instance_parameter_value intel_mipi_csi2 LANE {4}
    set_instance_parameter_value intel_mipi_csi2 NUMBER_OF_VIDEO_STREAMING_INTERFACES {1}
    set_instance_parameter_value intel_mipi_csi2 PIXELS_IN_PARALLEL {4}
    set_instance_parameter_value intel_mipi_csi2 SELECT_ED_FILESET {VERILOG}
    set_instance_parameter_value intel_mipi_csi2 SELECT_ED_SIM_VARIANT {fast}
    set_instance_parameter_value intel_mipi_csi2 SELECT_SUPPORTED_VARIANT {1}
    set_instance_parameter_value intel_mipi_csi2 SELECT_TARGETED_BOARD {0}
    set_instance_parameter_value intel_mipi_csi2 SUPPORT_LEGACY_YUV420_8B {0}
    set_instance_parameter_value intel_mipi_csi2 USE_CONTINUOUS_CLK {1}
    set_instance_parameter_value intel_mipi_csi2 VIDEO_INTERFACE_MODE {passthrough}

    #mipi_mm_ccb
    set_instance_parameter_value mipi_mm_ccb ADDRESS_UNITS {SYMBOLS}
    set_instance_parameter_value mipi_mm_ccb ADDRESS_WIDTH {14}
    set_instance_parameter_value mipi_mm_ccb COMMAND_FIFO_DEPTH {4}
    set_instance_parameter_value mipi_mm_ccb DATA_WIDTH {32}
    set_instance_parameter_value mipi_mm_ccb ENABLE_RESPONSE {0}
    set_instance_parameter_value mipi_mm_ccb MASTER_SYNC_DEPTH {2}
    set_instance_parameter_value mipi_mm_ccb MAX_BURST_SIZE {1}
    set_instance_parameter_value mipi_mm_ccb RESPONSE_FIFO_DEPTH {4}
    set_instance_parameter_value mipi_mm_ccb SLAVE_SYNC_DEPTH {2}
    set_instance_parameter_value mipi_mm_ccb SYMBOL_WIDTH {8}
    set_instance_parameter_value mipi_mm_ccb SYNC_RESET {1}
    set_instance_parameter_value mipi_mm_ccb USE_AUTO_ADDRESS_WIDTH {1}

    # mipi_dphy
    set_instance_parameter_value mipi_dphy EX_DESIGN_GEN_BSI {0}
    set_instance_parameter_value mipi_dphy EX_DESIGN_GEN_CDC {0}
    set_instance_parameter_value mipi_dphy EX_DESIGN_GEN_SIM {1}
    set_instance_parameter_value mipi_dphy EX_DESIGN_GEN_SYNTH {1}
    set_instance_parameter_value mipi_dphy EX_DESIGN_HDL_FORMAT {HDL_FORMAT_VERILOG}
    set_instance_parameter_value mipi_dphy EX_DESIGN_OSC_CLK_1_FREQ {OSC_CLK_1_125MHZ}
    set_instance_parameter_value mipi_dphy EX_DESIGN_SIM_CHK_PAR {0}
    set_instance_parameter_value mipi_dphy EX_DESIGN_SIM_LOOPBACK {1}
    set_instance_parameter_value mipi_dphy EX_DESIGN_SYNTH_MIRROR {0}
    set_instance_parameter_value mipi_dphy EX_DESIGN_TEST_COUNT {10}
    set_instance_parameter_value mipi_dphy GUI_ALT_CAL_EN_0 {0}
    set_instance_parameter_value mipi_dphy GUI_ALT_CAL_EN_1 {0}
    set_instance_parameter_value mipi_dphy GUI_ALT_CAL_EN_2 {0}
    set_instance_parameter_value mipi_dphy GUI_ALT_CAL_EN_3 {0}
    set_instance_parameter_value mipi_dphy GUI_ALT_CAL_EN_4 {0}
    set_instance_parameter_value mipi_dphy GUI_ALT_CAL_EN_5 {0}
    set_instance_parameter_value mipi_dphy GUI_ALT_CAL_EN_6 {0}
    set_instance_parameter_value mipi_dphy GUI_ALT_CAL_EN_7 {0}
    set_instance_parameter_value mipi_dphy GUI_ALT_CAL_LEN {65536}
    set_instance_parameter_value mipi_dphy GUI_BIT_RATE_MBPS_RNG_0 {1782.0}
    set_instance_parameter_value mipi_dphy GUI_BIT_RATE_MBPS_RNG_1 {1782.0}
    set_instance_parameter_value mipi_dphy GUI_BIT_RATE_MBPS_RNG_2 {1600.0}
    set_instance_parameter_value mipi_dphy GUI_BIT_RATE_MBPS_RNG_3 {1600.0}
    set_instance_parameter_value mipi_dphy GUI_BIT_RATE_MBPS_RNG_4 {1600.0}
    set_instance_parameter_value mipi_dphy GUI_BIT_RATE_MBPS_RNG_5 {1600.0}
    set_instance_parameter_value mipi_dphy GUI_BIT_RATE_MBPS_RNG_6 {1600.0}
    set_instance_parameter_value mipi_dphy GUI_BIT_RATE_MBPS_RNG_7 {1600.0}
    set_instance_parameter_value mipi_dphy GUI_BYTE_LOC_0 {1}
    set_instance_parameter_value mipi_dphy GUI_BYTE_LOC_1 {2}
    set_instance_parameter_value mipi_dphy GUI_BYTE_LOC_2 {2}
    set_instance_parameter_value mipi_dphy GUI_BYTE_LOC_3 {3}
    set_instance_parameter_value mipi_dphy GUI_BYTE_LOC_4 {4}
    set_instance_parameter_value mipi_dphy GUI_BYTE_LOC_5 {5}
    set_instance_parameter_value mipi_dphy GUI_BYTE_LOC_6 {6}
    set_instance_parameter_value mipi_dphy GUI_BYTE_LOC_7 {7}
    set_instance_parameter_value mipi_dphy GUI_CONTINUOUS_CLK_0 {0}
    set_instance_parameter_value mipi_dphy GUI_CONTINUOUS_CLK_1 {0}
    set_instance_parameter_value mipi_dphy GUI_CONTINUOUS_CLK_2 {0}
    set_instance_parameter_value mipi_dphy GUI_CONTINUOUS_CLK_3 {0}
    set_instance_parameter_value mipi_dphy GUI_CONTINUOUS_CLK_4 {0}
    set_instance_parameter_value mipi_dphy GUI_CONTINUOUS_CLK_5 {0}
    set_instance_parameter_value mipi_dphy GUI_CONTINUOUS_CLK_6 {0}
    set_instance_parameter_value mipi_dphy GUI_CONTINUOUS_CLK_7 {0}
    set_instance_parameter_value mipi_dphy GUI_CORE_CLK_DIV_0 {8}
    set_instance_parameter_value mipi_dphy GUI_CORE_CLK_DIV_1 {8}
    set_instance_parameter_value mipi_dphy GUI_DPHY_IP_ROLE_0 {0}
    set_instance_parameter_value mipi_dphy GUI_DPHY_IP_ROLE_1 {2}
    set_instance_parameter_value mipi_dphy GUI_DPHY_IP_ROLE_2 {2}
    set_instance_parameter_value mipi_dphy GUI_DPHY_IP_ROLE_3 {2}
    set_instance_parameter_value mipi_dphy GUI_DPHY_IP_ROLE_4 {2}
    set_instance_parameter_value mipi_dphy GUI_DPHY_IP_ROLE_5 {2}
    set_instance_parameter_value mipi_dphy GUI_DPHY_IP_ROLE_6 {2}
    set_instance_parameter_value mipi_dphy GUI_DPHY_IP_ROLE_7 {2}
    set_instance_parameter_value mipi_dphy GUI_NUM_LANES_0 {4}
    set_instance_parameter_value mipi_dphy GUI_NUM_LANES_1 {4}
    set_instance_parameter_value mipi_dphy GUI_NUM_LANES_2 {1}
    set_instance_parameter_value mipi_dphy GUI_NUM_LANES_3 {1}
    set_instance_parameter_value mipi_dphy GUI_NUM_LANES_4 {1}
    set_instance_parameter_value mipi_dphy GUI_NUM_LANES_5 {1}
    set_instance_parameter_value mipi_dphy GUI_NUM_LANES_6 {1}
    set_instance_parameter_value mipi_dphy GUI_NUM_LANES_7 {1}
    set_instance_parameter_value mipi_dphy GUI_NUM_PLL {1}
    set_instance_parameter_value mipi_dphy GUI_PER_SKEW_CAL_EN_0 {0}
    set_instance_parameter_value mipi_dphy GUI_PER_SKEW_CAL_EN_1 {0}
    set_instance_parameter_value mipi_dphy GUI_PER_SKEW_CAL_EN_2 {0}
    set_instance_parameter_value mipi_dphy GUI_PER_SKEW_CAL_EN_3 {0}
    set_instance_parameter_value mipi_dphy GUI_PER_SKEW_CAL_EN_4 {0}
    set_instance_parameter_value mipi_dphy GUI_PER_SKEW_CAL_EN_5 {0}
    set_instance_parameter_value mipi_dphy GUI_PER_SKEW_CAL_EN_6 {0}
    set_instance_parameter_value mipi_dphy GUI_PER_SKEW_CAL_EN_7 {0}
    set_instance_parameter_value mipi_dphy GUI_PPI_WIDTH_USR_0 {16}
    set_instance_parameter_value mipi_dphy GUI_PPI_WIDTH_USR_1 {16}
    set_instance_parameter_value mipi_dphy GUI_PPI_WIDTH_USR_2 {16}
    set_instance_parameter_value mipi_dphy GUI_PPI_WIDTH_USR_3 {16}
    set_instance_parameter_value mipi_dphy GUI_PPI_WIDTH_USR_4 {16}
    set_instance_parameter_value mipi_dphy GUI_PPI_WIDTH_USR_5 {16}
    set_instance_parameter_value mipi_dphy GUI_PPI_WIDTH_USR_6 {16}
    set_instance_parameter_value mipi_dphy GUI_PPI_WIDTH_USR_7 {16}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_0_0 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_0_1 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_0_2 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_0_3 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_0_4 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_0_5 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_0_6 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_0_7 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_1_0 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_1_1 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_1_2 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_1_3 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_1_4 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_1_5 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_1_6 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_1_7 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_2_0 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_2_1 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_2_2 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_2_3 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_2_4 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_2_5 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_2_6 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_2_7 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_3_0 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_3_1 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_3_2 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_3_3 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_3_4 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_3_5 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_3_6 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_3_7 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_4_0 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_4_1 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_4_2 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_4_3 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_4_4 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_4_5 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_4_6 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_4_7 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_5_0 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_5_1 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_5_2 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_5_3 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_5_4 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_5_5 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_5_6 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_5_7 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_6_0 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_6_1 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_6_2 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_6_3 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_6_4 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_6_5 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_6_6 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_6_7 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_7_0 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_7_1 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_7_2 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_7_3 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_7_4 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_7_5 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_7_6 {255}
    set_instance_parameter_value mipi_dphy GUI_PRBS_INIT_7_7 {255}
    set_instance_parameter_value mipi_dphy GUI_PREAMBLE_EN_0 {0}
    set_instance_parameter_value mipi_dphy GUI_PREAMBLE_EN_1 {0}
    set_instance_parameter_value mipi_dphy GUI_PREAMBLE_EN_2 {0}
    set_instance_parameter_value mipi_dphy GUI_PREAMBLE_EN_3 {0}
    set_instance_parameter_value mipi_dphy GUI_PREAMBLE_EN_4 {0}
    set_instance_parameter_value mipi_dphy GUI_PREAMBLE_EN_5 {0}
    set_instance_parameter_value mipi_dphy GUI_PREAMBLE_EN_6 {0}
    set_instance_parameter_value mipi_dphy GUI_PREAMBLE_EN_7 {0}
    set_instance_parameter_value mipi_dphy GUI_REF_CLK_FREQ_MHZ_0 {100.0}
    set_instance_parameter_value mipi_dphy GUI_REF_CLK_FREQ_MHZ_1 {20.0}
    set_instance_parameter_value mipi_dphy GUI_REF_CLK_IO_0 {1}
    set_instance_parameter_value mipi_dphy GUI_REF_CLK_IO_1 {0}
    set_instance_parameter_value mipi_dphy GUI_REF_CLK_IO_SHARE {1}
    set_instance_parameter_value mipi_dphy GUI_RX_AUTO_TYPE_0 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_AUTO_TYPE_1 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_AUTO_TYPE_2 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_AUTO_TYPE_3 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_AUTO_TYPE_4 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_AUTO_TYPE_5 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_AUTO_TYPE_6 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_AUTO_TYPE_7 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_BIT_RATE_MBPS_SEL_0 {64}
    set_instance_parameter_value mipi_dphy GUI_RX_BIT_RATE_MBPS_SEL_1 {64}
    set_instance_parameter_value mipi_dphy GUI_RX_BIT_RATE_MBPS_SEL_2 {64}
    set_instance_parameter_value mipi_dphy GUI_RX_BIT_RATE_MBPS_SEL_3 {64}
    set_instance_parameter_value mipi_dphy GUI_RX_BIT_RATE_MBPS_SEL_4 {64}
    set_instance_parameter_value mipi_dphy GUI_RX_BIT_RATE_MBPS_SEL_5 {64}
    set_instance_parameter_value mipi_dphy GUI_RX_BIT_RATE_MBPS_SEL_6 {64}
    set_instance_parameter_value mipi_dphy GUI_RX_BIT_RATE_MBPS_SEL_7 {64}
    set_instance_parameter_value mipi_dphy GUI_RX_CAP_EQ_MODE_0 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_CAP_EQ_MODE_1 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_CAP_EQ_MODE_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_CAP_EQ_MODE_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_CAP_EQ_MODE_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_CAP_EQ_MODE_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_CAP_EQ_MODE_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_CAP_EQ_MODE_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_0 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_1 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_2 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_3 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_4 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_5 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_6 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_7 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_LOSS_DETECT_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_POST_0 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_POST_1 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_POST_2 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_POST_3 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_POST_4 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_POST_5 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_POST_6 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_POST_7 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_0 {7}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_1 {7}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_2 {7}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_3 {7}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_4 {7}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_5 {7}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_6 {7}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_7 {7}
    set_instance_parameter_value mipi_dphy GUI_RX_CLK_SETTLE_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_0_0 {48}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_0_1 {48}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_0_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_0_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_0_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_0_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_0_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_0_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_1_0 {48}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_1_1 {48}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_1_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_1_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_1_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_1_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_1_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_1_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_2_0 {48}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_2_1 {48}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_2_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_2_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_2_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_2_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_2_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_2_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_3_0 {48}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_3_1 {48}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_3_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_3_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_3_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_3_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_3_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_3_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_4_0 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_4_1 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_4_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_4_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_4_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_4_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_4_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_4_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_5_0 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_5_1 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_5_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_5_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_5_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_5_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_5_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_5_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_6_0 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_6_1 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_6_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_6_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_6_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_6_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_6_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_6_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_7_0 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_7_1 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_7_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_7_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_7_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_7_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_7_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_DLANE_DESKEW_DELAY_7_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_0 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_1 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_2 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_3 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_4 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_5 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_6 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_7 {2}
    set_instance_parameter_value mipi_dphy GUI_RX_HS_SETTLE_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_0 {12}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_1 {12}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_2 {12}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_3 {12}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_4 {12}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_5 {12}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_6 {12}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_7 {12}
    set_instance_parameter_value mipi_dphy GUI_RX_INIT_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_RX_PREP_TIME_TM_0 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_PREP_TIME_TM_1 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_PREP_TIME_TM_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_PREP_TIME_TM_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_PREP_TIME_TM_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_PREP_TIME_TM_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_PREP_TIME_TM_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_PREP_TIME_TM_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TIMING_RW_0 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_TIMING_RW_1 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_TIMING_RW_2 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_TIMING_RW_3 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_TIMING_RW_4 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_TIMING_RW_5 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_TIMING_RW_6 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_TIMING_RW_7 {1}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_EN_0 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_EN_1 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_EN_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_EN_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_EN_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_EN_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_EN_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_EN_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_0 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_1 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_2 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_3 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_4 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_5 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_6 {0}
    set_instance_parameter_value mipi_dphy GUI_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_7 {0}
    set_instance_parameter_value mipi_dphy GUI_RZQ_ID {1}
    set_instance_parameter_value mipi_dphy GUI_RZQ_SHARING {0}
    set_instance_parameter_value mipi_dphy GUI_SKEW_CAL_EN_0 {0}
    set_instance_parameter_value mipi_dphy GUI_SKEW_CAL_EN_1 {0}
    set_instance_parameter_value mipi_dphy GUI_SKEW_CAL_EN_2 {0}
    set_instance_parameter_value mipi_dphy GUI_SKEW_CAL_EN_3 {0}
    set_instance_parameter_value mipi_dphy GUI_SKEW_CAL_EN_4 {0}
    set_instance_parameter_value mipi_dphy GUI_SKEW_CAL_EN_5 {0}
    set_instance_parameter_value mipi_dphy GUI_SKEW_CAL_EN_6 {0}
    set_instance_parameter_value mipi_dphy GUI_SKEW_CAL_EN_7 {0}
    set_instance_parameter_value mipi_dphy GUI_SKEW_CAL_LEN {32768}
    set_instance_parameter_value mipi_dphy GUI_SOURCE_PLL_0 {0}
    set_instance_parameter_value mipi_dphy GUI_SOURCE_PLL_1 {0}
    set_instance_parameter_value mipi_dphy GUI_SOURCE_PLL_2 {0}
    set_instance_parameter_value mipi_dphy GUI_SOURCE_PLL_3 {0}
    set_instance_parameter_value mipi_dphy GUI_SOURCE_PLL_4 {0}
    set_instance_parameter_value mipi_dphy GUI_SOURCE_PLL_5 {0}
    set_instance_parameter_value mipi_dphy GUI_SOURCE_PLL_6 {0}
    set_instance_parameter_value mipi_dphy GUI_SOURCE_PLL_7 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_EN_0 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_EN_1 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_EN_2 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_EN_3 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_EN_4 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_EN_5 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_EN_6 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_EN_7 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_LOOPBACK_MODE_0 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_LOOPBACK_MODE_1 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_LOOPBACK_MODE_2 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_LOOPBACK_MODE_3 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_LOOPBACK_MODE_4 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_LOOPBACK_MODE_5 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_LOOPBACK_MODE_6 {0}
    set_instance_parameter_value mipi_dphy GUI_TM_LOOPBACK_MODE_7 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_AUTO_TYPE_0 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_AUTO_TYPE_1 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_AUTO_TYPE_2 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_AUTO_TYPE_3 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_AUTO_TYPE_4 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_AUTO_TYPE_5 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_AUTO_TYPE_6 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_AUTO_TYPE_7 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_CAP_EQ_MODE_0 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_CAP_EQ_MODE_1 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_CAP_EQ_MODE_2 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_CAP_EQ_MODE_3 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_CAP_EQ_MODE_4 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_CAP_EQ_MODE_5 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_CAP_EQ_MODE_6 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_CAP_EQ_MODE_7 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_LANE_PS_0 {32}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_LANE_PS_1 {32}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_LANE_PS_2 {32}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_LANE_PS_3 {32}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_LANE_PS_4 {32}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_LANE_PS_5 {32}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_LANE_PS_6 {32}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_LANE_PS_7 {32}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_0 {7}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_1 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_2 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_3 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_4 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_5 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_6 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_7 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_POST_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_0 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_1 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_2 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_3 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_4 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_5 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_6 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_7 {2}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PREPARE_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_0 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_1 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_2 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_3 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_4 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_5 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_6 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_7 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_PRE_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_0 {7}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_1 {7}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_2 {7}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_3 {7}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_4 {7}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_5 {7}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_6 {7}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_7 {7}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_TRAIL_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_0 {22}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_1 {22}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_2 {22}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_3 {22}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_4 {22}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_5 {22}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_6 {22}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_7 {22}
    set_instance_parameter_value mipi_dphy GUI_TX_CLK_ZERO_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_0 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_1 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_2 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_3 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_4 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_5 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_6 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_7 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_EXIT_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_0 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_1 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_2 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_3 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_4 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_5 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_6 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_7 {3}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_PREPARE_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TM_DESKEW_P_0 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TM_DESKEW_P_1 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TM_DESKEW_P_2 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TM_DESKEW_P_3 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TM_DESKEW_P_4 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TM_DESKEW_P_5 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TM_DESKEW_P_6 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TM_DESKEW_P_7 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_0 {8}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_1 {8}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_2 {8}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_3 {8}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_4 {8}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_5 {8}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_6 {8}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_7 {8}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_TRAIL_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_0 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_1 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_2 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_3 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_4 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_5 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_6 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_7 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_HS_ZERO_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_0 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_1 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_2 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_3 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_4 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_5 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_6 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_7 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_INIT_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_0 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_1 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_2 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_3 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_4 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_5 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_6 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_7 {6}
    set_instance_parameter_value mipi_dphy GUI_TX_LPX_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_0 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_1 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_2 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_3 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_4 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_5 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_6 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_7 {12}
    set_instance_parameter_value mipi_dphy GUI_TX_LP_EXIT_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_PREAMBLE_LEN_PREAMLBE_LEN_0 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_PREAMBLE_LEN_PREAMLBE_LEN_1 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_PREAMBLE_LEN_PREAMLBE_LEN_2 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_PREAMBLE_LEN_PREAMLBE_LEN_3 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_PREAMBLE_LEN_PREAMLBE_LEN_4 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_PREAMBLE_LEN_PREAMLBE_LEN_5 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_PREAMBLE_LEN_PREAMLBE_LEN_6 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_PREAMBLE_LEN_PREAMLBE_LEN_7 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TIMING_RW_0 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_TIMING_RW_1 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_TIMING_RW_2 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_TIMING_RW_3 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_TIMING_RW_4 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_TIMING_RW_5 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_TIMING_RW_6 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_TIMING_RW_7 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_EN_0 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_EN_1 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_EN_2 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_EN_3 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_EN_4 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_EN_5 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_EN_6 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_EN_7 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_0 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_1 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_2 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_3 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_4 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_5 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_6 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_7 {0}
    set_instance_parameter_value mipi_dphy GUI_TX_VCO_FREQ_MULT_0 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_VCO_FREQ_MULT_1 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_VCO_FREQ_MULT_2 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_VCO_FREQ_MULT_3 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_VCO_FREQ_MULT_4 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_VCO_FREQ_MULT_5 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_VCO_FREQ_MULT_6 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_VCO_FREQ_MULT_7 {1}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_0 {111}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_0_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_1 {111}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_1_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_2 {111}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_2_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_3 {111}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_3_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_4 {111}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_4_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_5 {111}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_5_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_6 {111}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_6_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_7 {111}
    set_instance_parameter_value mipi_dphy GUI_TX_WAKE_7_AUTO_BOOL {1}
    set_instance_parameter_value mipi_dphy GUI_VCO_FREQ_MHZ_0 {600.0}
    set_instance_parameter_value mipi_dphy GUI_VCO_FREQ_MHZ_1 {800.0}

    #mipi_mm_bridge
    set_instance_parameter_value mipi_mm_bridge ADDRESS_UNITS {SYMBOLS}
    set_instance_parameter_value mipi_mm_bridge ADDRESS_WIDTH {16}
    set_instance_parameter_value mipi_mm_bridge DATA_WIDTH {32}
    set_instance_parameter_value mipi_mm_bridge LINEWRAPBURSTS {0}
    set_instance_parameter_value mipi_mm_bridge M0_WAITREQUEST_ALLOWANCE {0}
    set_instance_parameter_value mipi_mm_bridge MAX_BURST_SIZE {1}
    set_instance_parameter_value mipi_mm_bridge MAX_PENDING_RESPONSES {4}
    set_instance_parameter_value mipi_mm_bridge MAX_PENDING_WRITES {0}
    set_instance_parameter_value mipi_mm_bridge PIPELINE_COMMAND {1}
    set_instance_parameter_value mipi_mm_bridge PIPELINE_RESPONSE {1}
    set_instance_parameter_value mipi_mm_bridge S0_WAITREQUEST_ALLOWANCE {0}
    set_instance_parameter_value mipi_mm_bridge SYMBOL_WIDTH {8}
    set_instance_parameter_value mipi_mm_bridge SYNC_RESET {1}
    set_instance_parameter_value mipi_mm_bridge USE_AUTO_ADDRESS_WIDTH {1}
    set_instance_parameter_value mipi_mm_bridge USE_RESPONSE {0}
    set_instance_parameter_value mipi_mm_bridge USE_WRITERESPONSE {0}

    save_system

    load_system   ${v_project_path}/rtl/user/${v_instance_name}.qsys

    add_interface                i_clk_mipi_vid    clock       sink
    set_interface_property       i_clk_mipi_vid    export_of   mipi_vid_clk_bridge.in_clk

    add_interface                i_rst_mipi_vid    reset       sink
    set_interface_property       i_rst_mipi_vid    export_of   mipi_vid_rst_bridge.in_reset

    add_interface                i_clk_mipi_cpu    clock       sink
    set_interface_property       i_clk_mipi_cpu    export_of   mipi_cpu_clk_bridge.in_clk

    add_interface                i_rst_mipi_cpu    reset       sink
    set_interface_property       i_rst_mipi_cpu    export_of   mipi_cpu_rst_bridge.in_reset

    add_interface                c_rzq             conduit     INPUT
    set_interface_property       c_rzq             EXPORT_OF   mipi_dphy.rzq

    add_interface                i_clk_ref         clock       sink
    set_interface_property       i_clk_ref         EXPORT_OF   mipi_dphy.ref_clk_0

    add_interface                c_LINK0_dphy_io   conduit     INPUT
    set_interface_property       c_LINK0_dphy_io   EXPORT_OF   mipi_dphy.LINK0_dphy_io

    add_interface                c_ext_conn        conduit     INPUT
    set_interface_property       c_ext_conn        EXPORT_OF   mipi_pio.external_connection

    add_interface                agent_avalon_ctrl avalon      agent
    set_interface_property       agent_avalon_ctrl EXPORT_OF   mipi_mm_bridge.s0

    add_interface                mipi_packet_interface     axi4stream        OUTPUT
    set_interface_property       mipi_packet_interface     EXPORT_OF         intel_mipi_csi2.mipi_packet_interface

    add_connection mipi_mm_bridge.m0/mipi_dphy.axi_lite
    add_connection mipi_mm_bridge.m0/mipi_mm_ccb.s0
    add_connection mipi_mm_bridge.m0/mipi_pio.s1

    add_connection intel_mipi_csi2.ck_ppi_hs/mipi_dphy.LINK0_CK_ppi_rx_hs
    add_connection intel_mipi_csi2.ck_ppi_lp/mipi_dphy.LINK0_CK_ppi_rx_lp
    add_connection intel_mipi_csi2.d0_ppi_hs/mipi_dphy.LINK0_D0_ppi_rx_hs
    add_connection intel_mipi_csi2.d0_ppi_lp/mipi_dphy.LINK0_D0_ppi_rx_lp
    add_connection intel_mipi_csi2.d1_ppi_hs/mipi_dphy.LINK0_D1_ppi_rx_hs
    add_connection intel_mipi_csi2.d1_ppi_lp/mipi_dphy.LINK0_D1_ppi_rx_lp
    add_connection intel_mipi_csi2.d2_ppi_hs/mipi_dphy.LINK0_D2_ppi_rx_hs
    add_connection intel_mipi_csi2.d2_ppi_lp/mipi_dphy.LINK0_D2_ppi_rx_lp
    add_connection intel_mipi_csi2.d3_ppi_hs/mipi_dphy.LINK0_D3_ppi_rx_hs
    add_connection intel_mipi_csi2.d3_ppi_lp/mipi_dphy.LINK0_D3_ppi_rx_lp
    add_connection intel_mipi_csi2.i_ck_ppi_rx_err/mipi_dphy.LINK0_CK_ppi_rx_err
    add_connection intel_mipi_csi2.i_d0_ppi_rx_err/mipi_dphy.LINK0_D0_ppi_rx_err
    add_connection intel_mipi_csi2.i_d1_ppi_rx_err/mipi_dphy.LINK0_D1_ppi_rx_err
    add_connection intel_mipi_csi2.i_d2_ppi_rx_err/mipi_dphy.LINK0_D2_ppi_rx_err
    add_connection intel_mipi_csi2.i_d3_ppi_rx_err/mipi_dphy.LINK0_D3_ppi_rx_err

    add_connection mipi_dphy.LINK0_CK_ppi_ctrl/intel_mipi_csi2.ck_ppi_ctrl
    add_connection mipi_dphy.LINK0_CK_ppi_rx_hs_clk/intel_mipi_csi2.ck_ppi_hs_clk
    add_connection mipi_dphy.LINK0_CK_ppi_rx_hs_srst/intel_mipi_csi2.ck_ppi_rx_hs_srst
    add_connection mipi_dphy.LINK0_D0_ppi_ctrl/intel_mipi_csi2.d0_ppi_ctrl
    add_connection mipi_dphy.LINK0_D0_ppi_rx_hs_clk/intel_mipi_csi2.d0_ppi_hs_clk
    add_connection mipi_dphy.LINK0_D0_ppi_rx_hs_srst/intel_mipi_csi2.d0_ppi_rx_hs_srst
    add_connection mipi_dphy.LINK0_D1_ppi_ctrl/intel_mipi_csi2.d1_ppi_ctrl
    add_connection mipi_dphy.LINK0_D1_ppi_rx_hs_clk/intel_mipi_csi2.d1_ppi_hs_clk
    add_connection mipi_dphy.LINK0_D1_ppi_rx_hs_srst/intel_mipi_csi2.d1_ppi_rx_hs_srst
    add_connection mipi_dphy.LINK0_D2_ppi_ctrl/intel_mipi_csi2.d2_ppi_ctrl
    add_connection mipi_dphy.LINK0_D2_ppi_rx_hs_clk/intel_mipi_csi2.d2_ppi_hs_clk
    add_connection mipi_dphy.LINK0_D2_ppi_rx_hs_srst/intel_mipi_csi2.d2_ppi_rx_hs_srst
    add_connection mipi_dphy.LINK0_D3_ppi_ctrl/intel_mipi_csi2.d3_ppi_ctrl
    add_connection mipi_dphy.LINK0_D3_ppi_rx_hs_clk/intel_mipi_csi2.d3_ppi_hs_clk
    add_connection mipi_dphy.LINK0_D3_ppi_rx_hs_srst/intel_mipi_csi2.d3_ppi_rx_hs_srst

    add_connection mipi_mm_ccb.m0/intel_mipi_csi2.avalon_mm_control_interface
    add_connection mipi_vid_clk_bridge.out_clk/mipi_vid_rst_bridge.clk
    add_connection mipi_vid_clk_bridge.out_clk/mipi_mm_ccb.m0_clk

    add_connection mipi_vid_clk_bridge.out_clk/intel_mipi_csi2.axi4s_clk

    add_connection mipi_vid_rst_bridge.out_reset/mipi_mm_ccb.m0_reset
    add_connection mipi_vid_rst_bridge.out_reset/intel_mipi_csi2.axi4s_rst

    add_connection mipi_cpu_clk_bridge.out_clk/mipi_cpu_rst_bridge.clk
    add_connection mipi_cpu_clk_bridge.out_clk/mipi_pio.clk
    add_connection mipi_cpu_clk_bridge.out_clk/mipi_mm_ccb.s0_clk
    add_connection mipi_cpu_clk_bridge.out_clk/mipi_dphy.reg_clk
    add_connection mipi_cpu_clk_bridge.out_clk/mipi_mm_bridge.clk

    add_connection mipi_cpu_rst_bridge.out_reset/mipi_pio.reset
    add_connection mipi_cpu_rst_bridge.out_reset/mipi_mm_ccb.s0_reset
    add_connection mipi_cpu_rst_bridge.out_reset/mipi_dphy.arst
    add_connection mipi_cpu_rst_bridge.out_reset/mipi_dphy.reg_srst
    add_connection mipi_cpu_rst_bridge.out_reset/mipi_mm_bridge.reset


    sync_sysinfo_parameters
    save_system

}

# insert the subsystem into the top level qsys system, and add interfaces
# to the boundary of the top level qsys system

proc edit_top_level_qsys {} {

    set v_project_name  [get_shell_parameter PROJECT_NAME]
    set v_project_path  [get_shell_parameter PROJECT_PATH]
    set v_instance_name [get_shell_parameter INSTANCE_NAME]

    load_system ${v_project_path}/rtl/${v_project_name}_qsys.qsys

    add_instance  ${v_instance_name}  ${v_instance_name}

    add_interface           ${v_instance_name}_c_rzq           conduit   INPUT
    set_interface_property  ${v_instance_name}_c_rzq           EXPORT_OF ${v_instance_name}.c_rzq

    add_interface           ${v_instance_name}_i_clk_ref       clock     INPUT
    set_interface_property  ${v_instance_name}_i_clk_ref       EXPORT_OF ${v_instance_name}.i_clk_ref

    add_interface           ${v_instance_name}_c_LINK0_dphy_io conduit   INPUT
    set_interface_property  ${v_instance_name}_c_LINK0_dphy_io EXPORT_OF ${v_instance_name}.c_LINK0_dphy_io

    add_interface           ${v_instance_name}_c_ext_conn      conduit   INPUT
    set_interface_property  ${v_instance_name}_c_ext_conn      EXPORT_OF ${v_instance_name}.c_ext_conn

    sync_sysinfo_parameters
    save_system

}

# enable a subset of subsystem interfaces to be available for auto-connection
# to other subsystems at the top qsys level

proc add_auto_connections {} {

    set v_instance_name   [get_shell_parameter INSTANCE_NAME]

    set v_vid_clk_freq    [get_shell_parameter VID_FREQ]
    set v_vid_clk_freq_hz [expr int(${v_vid_clk_freq} * 1000000)]

    set v_cpu_clk_freq    [get_shell_parameter CPU_CLK_FREQ]
    set v_cpu_clk_freq_hz [expr int(${v_cpu_clk_freq} * 1000000)]

    add_auto_connection ${v_instance_name} i_clk_mipi_vid          ${v_vid_clk_freq_hz}
    add_auto_connection ${v_instance_name} i_clk_mipi_cpu          ${v_cpu_clk_freq_hz}

    add_auto_connection ${v_instance_name} i_rst_mipi_vid          sif_rst
    add_auto_connection ${v_instance_name} i_rst_mipi_cpu          ${v_cpu_clk_freq_hz}
    add_auto_connection ${v_instance_name} agent_avalon_ctrl       mm_ctrl
    add_auto_connection ${v_instance_name} mipi_packet_interface   mipi_axis

}

# insert lines of code into the top level hdl file

proc edit_top_v_file {} {

    set v_instance_name   [get_shell_parameter INSTANCE_NAME]

    add_top_port_list input   "\[3:0\]"  "LINK0_dphy_io_dphy_link_d_p"
    add_top_port_list input   "\[3:0\]"  "LINK0_dphy_io_dphy_link_d_n"
    add_top_port_list input   ""         "LINK0_dphy_io_dphy_link_c_p"
    add_top_port_list input   ""         "LINK0_dphy_io_dphy_link_c_n"

    add_top_port_list input   ""         "mipi_ref_clk_0"

    add_top_port_list input   ""         "mipi_rzq"

    add_declaration_list wire     "\[31:0\]"                  "mipi_pio_0_in"
    add_declaration_list wire     "\[31:0\]"                  "mipi_pio_0_out"

    add_assignments_list          "mipi_pio_0_in\[31:12\]"    "20'b0"
    add_assignments_list          "mipi_pio_0_in\[11:8\]"     "4'b0001"

    add_assignments_list          "mipi_pio_0_in\[7:4\]"      "4'b0001"

    add_assignments_list          "mipi_pio_0_in\[3\]"        "1'b0"
    add_assignments_list          "mipi_pio_0_in\[2\]"        "1'b1"

    add_assignments_list          "mipi_pio_0_in\[1\]"        "1'b0"
    add_assignments_list          "mipi_pio_0_in\[0\]"        "1'b1"

    add_qsys_inst_exports_list ${v_instance_name}_c_ext_conn_in_port            mipi_pio_0_in
    add_qsys_inst_exports_list ${v_instance_name}_c_ext_conn_out_port           mipi_pio_0_out
    add_qsys_inst_exports_list ${v_instance_name}_c_LINK0_dphy_io_dphy_link_dp  LINK0_dphy_io_dphy_link_d_p
    add_qsys_inst_exports_list ${v_instance_name}_c_LINK0_dphy_io_dphy_link_dn  LINK0_dphy_io_dphy_link_d_n
    add_qsys_inst_exports_list ${v_instance_name}_c_LINK0_dphy_io_dphy_link_cp  LINK0_dphy_io_dphy_link_c_p
    add_qsys_inst_exports_list ${v_instance_name}_c_LINK0_dphy_io_dphy_link_cn  LINK0_dphy_io_dphy_link_c_n
    add_qsys_inst_exports_list ${v_instance_name}_i_clk_ref_clk                 mipi_ref_clk_0
    add_qsys_inst_exports_list ${v_instance_name}_c_rzq_rzq                     mipi_rzq

}

proc evaluate_terp {} {
    set v_project_name  [get_shell_parameter PROJECT_NAME]
    set v_project_path  [get_shell_parameter PROJECT_PATH]

    evaluate_terp_file  ${v_project_path}/quartus/user/mipi.qsf.terp              [list ${v_project_name}] 0 1
}
