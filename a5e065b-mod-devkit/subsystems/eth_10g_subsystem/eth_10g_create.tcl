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

set_shell_parameter GEN_CLK0_FREQ_MHZ        "312.5"
set_shell_parameter GEN_CLK1_FREQ_MHZ        "156.25"
set_shell_parameter CSR_CLK_FREQ_MHZ         "100"

proc pre_creation_step {} {

    transfer_files
    evaluate_terp
}

proc creation_step {} {

    eth_10g_subsystem
}

proc post_creation_step {} {

    edit_top_level_qsys
    add_auto_connections
    edit_top_v_file
}

proc post_connection_step {} {
}

# copy files from the user non_qpds_ip install directory to the target project directory
proc transfer_files {} {

    set v_project_path      [get_shell_parameter PROJECT_PATH]
    set v_script_path       [get_shell_parameter SUBSYSTEM_SOURCE_PATH]

    file_copy   ${v_script_path}/eth_ModKit.qsf.terp \
        ${v_project_path}/quartus/user/eth.qsf.terp
}

proc eth_10g_subsystem {} {

    set v_project_path    [get_shell_parameter PROJECT_PATH]
    set v_instance_name   [get_shell_parameter INSTANCE_NAME]

    create_system ${v_instance_name}
	
    save_system   ${v_project_path}/rtl/user/${v_instance_name}.qsys
    load_system   ${v_project_path}/rtl/user/${v_instance_name}.qsys

    # create instances

    add_instance eth_csr_clk_bridge             altera_clock_bridge
    add_instance eth_csr_rst_bridge             altera_reset_bridge

    add_instance xgmii_rx_coreclkin_bridge      altera_clock_bridge

    add_instance xgmii_tx_coreclkin_bridge      altera_clock_bridge

    add_instance eth_mge_phy                    intel_mge_phy
    add_instance eth_em10g32                    intel_eth_em10g32

    add_instance eth_systemclk_gts              intel_systemclk_gts
    add_instance eth_srcss_gts                  intel_srcss_gts

    add_instance eth_refclk_10g_clk_bridge      altera_clock_bridge

    #eth_mge_phy
    set_instance_parameter_value eth_mge_phy EXT_PHY_MGBASET          {0}
    set_instance_parameter_value eth_mge_phy EXT_PHY_NBASET           {1}
    set_instance_parameter_value eth_mge_phy SPEED_VARIANT            {4}
    set_instance_parameter_value eth_mge_phy ENABLE_IEEE1588          {0}
    set_instance_parameter_value eth_mge_phy PHY_IDENTIFIER           {0}
    set_instance_parameter_value eth_mge_phy DEFAULT_MODE             {3}
    set_instance_parameter_value eth_mge_phy PMA_PLL_REFCLK           {0}
    set_instance_parameter_value eth_mge_phy tx_spread_spectrum_en    {DISABLE}
    set_instance_parameter_value eth_mge_phy tx_invert_pin            {DISABLE}
    set_instance_parameter_value eth_mge_phy ux_txeq_main_tap         {52}
    set_instance_parameter_value eth_mge_phy ux_txeq_post_tap_1       {5}
    set_instance_parameter_value eth_mge_phy ux_txeq_pre_tap_1        {0}
    set_instance_parameter_value eth_mge_phy ux_txeq_pre_tap_2        {0}
    set_instance_parameter_value eth_mge_phy rx_adaptation_mode       {auto}
    set_instance_parameter_value eth_mge_phy rx_invert_pin            {DISABLE}
    set_instance_parameter_value eth_mge_phy rx_external_couple_type  {AC}
    set_instance_parameter_value eth_mge_phy rx_onchip_termination    {R_2}

    # eth_em10g32
    set_instance_parameter_value eth_em10g32 ENABLE_1G10G_MAC                {5}
    set_instance_parameter_value eth_em10g32 DATAPATH_OPTION                 {3}
    set_instance_parameter_value eth_em10g32 ENABLE_MEM_ECC                  {0}
    set_instance_parameter_value eth_em10g32 PREAMBLE_PASSTHROUGH            {0}
    set_instance_parameter_value eth_em10g32 ENABLE_PFC                      {0}
    set_instance_parameter_value eth_em10g32 ENABLE_SUPP_ADDR                {1}
    set_instance_parameter_value eth_em10g32 INSTANTIATE_STATISTICS          {1}
    set_instance_parameter_value eth_em10g32 REGISTER_BASED_STATISTICS       {0}
    set_instance_parameter_value eth_em10g32 ENABLE_TXRX_DATAPATH            {1}
    set_instance_parameter_value eth_em10g32 ENABLE_TIMESTAMPING             {0}
    set_instance_parameter_value eth_em10g32 INSERT_CSR_ADAPTOR              {0}
    set_instance_parameter_value eth_em10g32 INSERT_ST_ADAPTOR               {1}

    # eth_srcss_gts
    set_instance_parameter_value eth_srcss_gts SRC_RS_DISABLE                {false}
    set_instance_parameter_value eth_srcss_gts NUM_LANES_SHORELINE           {1}
    set_instance_parameter_value eth_srcss_gts NUM_BANKS_SHORELINE           {1}

    # eth_systemclk_gts
    set_instance_parameter_value eth_systemclk_gts syspll_use_case           {TRANSCEIVER_USE_CASE}
    set_instance_parameter_value eth_systemclk_gts syspll_mod_0              {User Configuration}
    set_instance_parameter_value eth_systemclk_gts syspll_freq_mhz_0         {644.53125}
    set_instance_parameter_value eth_systemclk_gts refclk_xcvr_freq_mhz_0    {156.250000}

    add_interface             i_clk_csr              clock             sink
    set_interface_property    i_clk_csr              export_of         eth_csr_clk_bridge.in_clk

    add_interface             i_rst_csr              reset             sink
    set_interface_property    i_rst_csr              export_of         eth_csr_rst_bridge.in_reset

    add_interface             i_clk_xgmii_rx_coreclk clock             sink
    set_interface_property    i_clk_xgmii_rx_coreclk export_of         xgmii_rx_coreclkin_bridge.in_clk

    add_interface             i_clk_xgmii_tx_coreclk clock             sink
    set_interface_property    i_clk_xgmii_tx_coreclk export_of         xgmii_tx_coreclkin_bridge.in_clk

    add_interface             i_clk_10g              clock             sink
    set_interface_property    i_clk_10g              export_of         eth_refclk_10g_clk_bridge.in_clk

    #eth_systemclk_gts interfaces
    add_interface             c_pll_lock             conduit           end
    set_interface_property    c_pll_lock             export_of         eth_systemclk_gts.o_pll_lock

    add_interface             c_refclk_rdy           conduit           end
    set_interface_property    c_refclk_rdy           export_of         eth_systemclk_gts.i_refclk_rdy

    #eth_srcss_gts interfaces
    add_interface             c_src_rs_priority      conduit           end
    set_interface_property    c_src_rs_priority      export_of         eth_srcss_gts.i_src_rs_priority

    #eth_em10g32 interfaces
    add_interface             c_avalon_st_pause      conduit           end
    set_interface_property    c_avalon_st_pause      export_of         eth_em10g32.avalon_st_pause

    add_interface             avalon_st_tx           avalon_streaming  input
    set_interface_property    avalon_st_tx           export_of         eth_em10g32.avalon_st_tx

    add_interface             avalon_st_rx           avalon_streaming  output
    set_interface_property    avalon_st_rx           export_of         eth_em10g32.avalon_st_rx

    #eth_mge_phy
    add_interface            c_clk_status            conduit           end
    set_interface_property   c_clk_status            export_of         eth_mge_phy.clock_status_ports_out

    add_interface            c_system_pll_lock       conduit           end
    set_interface_property   c_system_pll_lock       export_of         eth_mge_phy.i_system_pll_lock

    add_interface            c_serial                conduit           end
    set_interface_property   c_serial                export_of         eth_mge_phy.serial

    add_interface            c_rst_status            conduit           end
    set_interface_property   c_rst_status            export_of         eth_mge_phy.reset_status_ports

    add_interface            i_clk_pll               clock             input
    set_interface_property   i_clk_pll               export_of         eth_mge_phy.i_clk_pll

    add_interface            o_clk_pll               clock             output
    set_interface_property   o_clk_pll               export_of         eth_mge_phy.o_clk_pll

    add_interface            i_clk_tx_156_25         clock             INPUT
    set_interface_property   i_clk_tx_156_25         export_of         eth_em10g32.tx_156_25_clk

    add_interface            i_clk_rx_156_25         clock             INPUT
    set_interface_property   i_clk_rx_156_25         export_of         eth_em10g32.rx_156_25_clk

    # Add connections

    add_connection eth_csr_clk_bridge.out_clk          eth_mge_phy.csr_clk
    add_connection eth_csr_rst_bridge.out_reset        eth_mge_phy.reset

    add_connection eth_csr_clk_bridge.out_clk          eth_csr_rst_bridge.clk

    add_connection eth_csr_clk_bridge.out_clk          eth_em10g32.csr_clk
    add_connection eth_csr_rst_bridge.out_reset        eth_em10g32.csr_rst_n

    add_connection xgmii_tx_coreclkin_bridge.out_clk   eth_mge_phy.xgmii_rx_coreclkin
    add_connection xgmii_tx_coreclkin_bridge.out_clk   eth_mge_phy.xgmii_tx_coreclkin
    add_connection xgmii_tx_coreclkin_bridge.out_clk   eth_em10g32.rx_312_5_clk
    add_connection xgmii_tx_coreclkin_bridge.out_clk   eth_em10g32.tx_312_5_clk

    add_connection eth_em10g32.xgmii_rx_control        eth_mge_phy.xgmii_rx_control
    add_connection eth_em10g32.xgmii_tx_data           eth_mge_phy.xgmii_tx_data
    add_connection eth_em10g32.xgmii_tx_valid          eth_mge_phy.xgmii_tx_valid

    add_connection eth_mge_phy.operating_speed         eth_em10g32.speed_sel
    add_connection eth_mge_phy.xgmii_rx_data           eth_em10g32.xgmii_rx_data
    add_connection eth_mge_phy.xgmii_rx_valid          eth_em10g32.xgmii_rx_valid
    add_connection eth_mge_phy.xgmii_tx_control        eth_em10g32.xgmii_tx_control

    add_connection eth_srcss_gts.i_src_rs_req          eth_mge_phy.o_src_rs_req
    add_connection eth_srcss_gts.o_pma_cu_clk          eth_mge_phy.i_pma_cu_clk
    add_connection eth_srcss_gts.o_src_rs_grant        eth_mge_phy.i_src_rs_grant

    add_connection eth_mge_phy.o_refclk_bus_out        eth_srcss_gts.i_refclk_bus_out
    add_connection eth_systemclk_gts.o_syspll_c0       eth_mge_phy.i_system_pll_clk

    add_connection eth_csr_clk_bridge.out_clk          eth_mge_phy.reconfig_clk
    add_connection eth_csr_rst_bridge.out_reset        eth_mge_phy.reconfig_reset

    add_connection eth_refclk_10g_clk_bridge.out_clk   eth_mge_phy.tx_pll_refclk_p
    add_connection eth_refclk_10g_clk_bridge.out_clk   eth_systemclk_gts.refclk_xcvr

    add_connection eth_csr_rst_bridge.out_reset        eth_mge_phy.i_rst_n
    add_connection eth_csr_rst_bridge.out_reset        eth_mge_phy.i_tx_rst_n
    add_connection eth_csr_rst_bridge.out_reset        eth_mge_phy.i_rx_rst_n

    add_connection eth_csr_rst_bridge.out_reset        eth_em10g32.tx_rst_n
    add_connection eth_csr_rst_bridge.out_reset        eth_em10g32.rx_rst_n

    sync_sysinfo_parameters
    save_system
}

# insert the Ethernet subsystem into the top level Platform designer system, and add interfaces
# to the boundary of the top level Platform designer system

proc edit_top_level_qsys {} {

    set v_project_name  [get_shell_parameter PROJECT_NAME]
    set v_project_path  [get_shell_parameter PROJECT_PATH]
    set v_instance_name [get_shell_parameter INSTANCE_NAME]

    load_system ${v_project_path}/rtl/${v_project_name}_qsys.qsys

    add_instance  ${v_instance_name}  ${v_instance_name}

    # add interfaces to the boundary of the subsystem

    add_interface             ${v_instance_name}_c_src_rs_priority conduit      end
    set_interface_property    ${v_instance_name}_c_src_rs_priority export_of    ${v_instance_name}.c_src_rs_priority

    add_interface             ${v_instance_name}_c_refclk_rdy      conduit      end
    set_interface_property    ${v_instance_name}_c_refclk_rdy      export_of    ${v_instance_name}.c_refclk_rdy

    add_interface             ${v_instance_name}_c_system_pll_lock conduit      end
    set_interface_property    ${v_instance_name}_c_system_pll_lock export_of    ${v_instance_name}.c_system_pll_lock

    add_interface              ${v_instance_name}_i_clk_10g        clock        input
    set_interface_property     ${v_instance_name}_i_clk_10g        export_of    ${v_instance_name}.i_clk_10g

    add_interface             ${v_instance_name}_c_avalon_st_pause conduit      end
    set_interface_property    ${v_instance_name}_c_avalon_st_pause export_of    ${v_instance_name}.c_avalon_st_pause

    add_interface             ${v_instance_name}_c_clk_status      conduit      end
    set_interface_property    ${v_instance_name}_c_clk_status      export_of    ${v_instance_name}.c_clk_status

    add_interface             ${v_instance_name}_c_serial          conduit      end
    set_interface_property    ${v_instance_name}_c_serial          export_of    ${v_instance_name}.c_serial

    add_interface             ${v_instance_name}_c_rst_status      conduit      end
    set_interface_property    ${v_instance_name}_c_rst_status      export_of    ${v_instance_name}.c_rst_status

    add_interface             ${v_instance_name}_i_clk_pll         clock        input
    set_interface_property    ${v_instance_name}_i_clk_pll         export_of    ${v_instance_name}.i_clk_pll

    add_interface             ${v_instance_name}_c_pll_lock        conduit      end
    set_interface_property    ${v_instance_name}_c_pll_lock        export_of    ${v_instance_name}.c_pll_lock

    sync_sysinfo_parameters
    save_system
}

# enable a subset of subsystem interfaces to be available for auto-connection
# to other subsystems at the top qsys level

proc add_auto_connections {} {

    set v_instance_name       [get_shell_parameter INSTANCE_NAME]

    set v_csr_ref_clk_freq    [get_shell_parameter CSR_CLK_FREQ_MHZ]
    set v_csr_ref_clk_freq_hz [expr int(${v_csr_ref_clk_freq} * 1000000)]

    set v_freq_0              [get_shell_parameter GEN_CLK0_FREQ_MHZ]
    set v_freq_0_hz           [expr int(${v_freq_0} * 1000000)]

    set v_freq_1              [get_shell_parameter GEN_CLK1_FREQ_MHZ]
    set v_freq_1_hz           [expr int(${v_freq_1} * 1000000)]

    add_auto_connection ${v_instance_name} avalon_st_tx             av_src
    add_auto_connection ${v_instance_name} avalon_st_rx             av_sink

    add_auto_connection ${v_instance_name} i_clk_csr                ${v_csr_ref_clk_freq_hz}
    add_auto_connection ${v_instance_name} i_rst_csr                ${v_csr_ref_clk_freq_hz}

    add_auto_connection ${v_instance_name} o_clk_pll                ref_clk_ext
    add_auto_connection ${v_instance_name} i_clk_tx_156_25          ${v_freq_1_hz}
    add_auto_connection ${v_instance_name} i_clk_rx_156_25          ${v_freq_1_hz}

    add_auto_connection ${v_instance_name} i_clk_xgmii_tx_coreclk   ${v_freq_0_hz}
    add_auto_connection ${v_instance_name} i_clk_xgmii_rx_coreclk   ${v_freq_0_hz}
}

# insert lines of code into the top level hdl file
proc edit_top_v_file {} {

    set v_instance_name    [get_shell_parameter INSTANCE_NAME]

    add_qsys_inst_exports_list ${v_instance_name}_c_clk_status_o_cdr_lock            rx_is_lockedtodata
    add_qsys_inst_exports_list ${v_instance_name}_c_clk_status_o_tx_pll_locked       o_tx_pll_locked
    add_qsys_inst_exports_list ${v_instance_name}_c_clk_status_o_tx_lanes_stable     o_tx_lanes_stable
    add_qsys_inst_exports_list ${v_instance_name}_c_clk_status_o_rx_pcs_ready        o_rx_pcs_ready
    add_qsys_inst_exports_list ${v_instance_name}_c_rst_status_o_rst_ack_n           o_rst_ack_n
    add_qsys_inst_exports_list ${v_instance_name}_c_rst_status_o_tx_rst_ack_n        o_tx_rst_ack_n
    add_qsys_inst_exports_list ${v_instance_name}_c_rst_status_o_rx_rst_ack_n        o_rx_rst_ack_n
    add_qsys_inst_exports_list ${v_instance_name}_c_system_pll_lock_o_pll_lock       o_pll_lock
    add_qsys_inst_exports_list ${v_instance_name}_c_serial_o_tx_serial_data          serial_o_tx_serial_data
    add_qsys_inst_exports_list ${v_instance_name}_c_serial_i_rx_serial_data          serial_i_rx_serial_data
    add_qsys_inst_exports_list ${v_instance_name}_c_serial_o_tx_serial_data_n        serial_o_tx_serial_data_n
    add_qsys_inst_exports_list ${v_instance_name}_c_serial_i_rx_serial_data_n        serial_i_rx_serial_data_n
    add_qsys_inst_exports_list ${v_instance_name}_i_clk_pll_clk                      {"1'b0"}
    add_qsys_inst_exports_list ${v_instance_name}_c_src_rs_priority_src_rs_priority  {"1'b0"}
    add_qsys_inst_exports_list ${v_instance_name}_c_refclk_rdy_data                  {"1'b1"}
    add_qsys_inst_exports_list ${v_instance_name}_i_clk_10g_clk                      refclk_10g
    add_qsys_inst_exports_list ${v_instance_name}_c_pll_lock_o_pll_lock              o_pll_lock

    add_declaration_list wire ""          o_rst_ack_n
    add_declaration_list wire ""          o_tx_rst_ack_n
    add_declaration_list wire ""          o_rx_rst_ack_n
    add_declaration_list wire ""          o_tx_lanes_stable
    add_declaration_list wire ""          o_rx_pcs_ready
    add_declaration_list wire ""          rx_is_lockedtodata
    add_declaration_list wire ""          o_tx_pll_locked
    add_declaration_list wire ""          o_pll_lock

    add_top_port_list    input   ""       "serial_i_rx_serial_data"
    add_top_port_list    input   ""       "serial_i_rx_serial_data_n"
    add_top_port_list    input   ""       "refclk_10g"

    add_top_port_list    output  ""       "serial_o_tx_serial_data"
    add_top_port_list    output  ""       "serial_o_tx_serial_data_n"
    add_top_port_list    output  ""       "sfp_tx_disable"

    add_assignments_list "sfp_tx_disable"          {"1'b0"}

    add_assignments_list "clock_subsystem_i_rst_1" {~o_pll_lock}
    add_assignments_list "permit_cal"              {o_pll_lock}

}

proc evaluate_terp {} {

    set v_project_name  [get_shell_parameter PROJECT_NAME]
    set v_project_path  [get_shell_parameter PROJECT_PATH]

    evaluate_terp_file  ${v_project_path}/quartus/user/eth.qsf.terp    [list ${v_project_name}] 0 1
}
