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

set_shell_parameter HOST_INTF_CLK_FREQ_MHZ  "156.25"
set_shell_parameter APB_CLK_FREQ_MHZ        "100"

proc pre_creation_step {} {

    transfer_files
    evaluate_terp
}

proc creation_step {} {

    hsb_subsystem
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

    exec cp -rf ${v_script_path}/non_qpds_ip/hsb_axis_avst_shim         ${v_project_path}/non_qpds_ip/user
    exec cp -rf ${v_script_path}/non_qpds_ip/pd_hsb_ip                  ${v_project_path}/non_qpds_ip/user
    exec cp -rf ${v_script_path}/non_qpds_ip/hsb_avst_axis_shim         ${v_project_path}/non_qpds_ip/user
    exec cp -rf ${v_script_path}/non_qpds_ip/common_tcl                 ${v_project_path}/non_qpds_ip/user
    exec cp -rf ${v_script_path}/non_qpds_ip/hsb_mipi_holo_shim         ${v_project_path}/non_qpds_ip/user

    file_copy   ${v_script_path}/hsb_ModKit.qsf.terp \
        ${v_project_path}/quartus/user/hsb.qsf.terp

    file_copy   ${v_script_path}/hsb_subsystem.sdc.terp \
        ${v_project_path}/sdc/user/hsb_subsystem.sdc
}

proc hsb_subsystem {} {

    set v_project_path      [get_shell_parameter PROJECT_PATH]
    set v_instance_name     [get_shell_parameter INSTANCE_NAME]

    set v_host_intf_freq    [get_shell_parameter HOST_INTF_CLK_FREQ_MHZ]
    set v_host_intf_freq_hz [expr int(${v_host_intf_freq} * 1000000)]

    set v_apb_intf_freq     [get_shell_parameter APB_CLK_FREQ_MHZ]
    set v_apb_intf_freq_hz  [expr int(${v_apb_intf_freq} * 1000000)]

    create_system ${v_instance_name}
		
    save_system   ${v_project_path}/rtl/user/${v_instance_name}.qsys
    load_system   ${v_project_path}/rtl/user/${v_instance_name}.qsys

    # create instances

    add_instance cpu_clk_bridge                 altera_clock_bridge
    add_instance cpu_rst_bridge                 altera_reset_bridge

    add_instance hif_clk_bridge                 altera_clock_bridge
    add_instance hif_rst_bridge                 altera_reset_bridge
    add_instance hif_rst_output_bridge          altera_reset_bridge
    add_instance hif_clk_output_bridge          altera_clock_bridge

    add_instance hsb_avst_axis_shim             hsb_avst_axis_shim
    add_instance hsb_axis_avst_shim             hsb_axis_avst_shim

    add_instance hsb                            nvidia_hololink

    add_instance hsb_mm_bridge                  altera_avalon_mm_bridge
    add_instance hsb_mipi_holo_shim             hsb_mipi_holo_shim

    # hsb
    set_instance_parameter_value hsb APB_CLK_FREQ            ${v_apb_intf_freq_hz}
    set_instance_parameter_value hsb APB_INST                {1}
    set_instance_parameter_value hsb GPIO_INST               {16}
    set_instance_parameter_value hsb HIF_CLK_FREQ            ${v_host_intf_freq_hz}
    set_instance_parameter_value hsb HIF_INST                {1}
    set_instance_parameter_value hsb I2C_INST                {2}
    set_instance_parameter_value hsb SIF_INST                {1}
    set_instance_parameter_value hsb SPI_INST                {1}

    # hsb_avst_axis_shim
    set_instance_parameter_value hsb_avst_axis_shim C_AXIS_TUSER_WIDTH   {1}
    set_instance_parameter_value hsb_avst_axis_shim C_BYTE_SWAP          {1}
    set_instance_parameter_value hsb_avst_axis_shim C_M_AXIS_TDATA_WIDTH {64}

    # hsb_axis_avst_shim
    set_instance_parameter_value hsb_axis_avst_shim C_AXIS_TUSER_WIDTH   {1}
    set_instance_parameter_value hsb_axis_avst_shim C_BYTE_SWAP          {1}
    set_instance_parameter_value hsb_axis_avst_shim C_S_AXIS_TDATA_WIDTH {64}

    #hsb_mm_bridge
    set_instance_parameter_value hsb_mm_bridge ADDRESS_UNITS             {SYMBOLS}
    set_instance_parameter_value hsb_mm_bridge ADDRESS_WIDTH             {16}
    set_instance_parameter_value hsb_mm_bridge DATA_WIDTH                {32}
    set_instance_parameter_value hsb_mm_bridge LINEWRAPBURSTS            {0}
    set_instance_parameter_value hsb_mm_bridge M0_WAITREQUEST_ALLOWANCE  {0}
    set_instance_parameter_value hsb_mm_bridge MAX_BURST_SIZE            {1}
    set_instance_parameter_value hsb_mm_bridge MAX_PENDING_RESPONSES     {4}
    set_instance_parameter_value hsb_mm_bridge MAX_PENDING_WRITES        {0}
    set_instance_parameter_value hsb_mm_bridge PIPELINE_COMMAND          {1}
    set_instance_parameter_value hsb_mm_bridge PIPELINE_RESPONSE         {1}
    set_instance_parameter_value hsb_mm_bridge S0_WAITREQUEST_ALLOWANCE  {0}
    set_instance_parameter_value hsb_mm_bridge SYMBOL_WIDTH              {8}
    set_instance_parameter_value hsb_mm_bridge SYNC_RESET                {1}
    set_instance_parameter_value hsb_mm_bridge USE_AUTO_ADDRESS_WIDTH    {1}
    set_instance_parameter_value hsb_mm_bridge USE_RESPONSE              {0}
    set_instance_parameter_value hsb_mm_bridge USE_WRITERESPONSE         {0}

    #hsb_mipi_holo_shim
    set_instance_parameter_value hsb_mipi_holo_shim C_AXIS_TDATA_WIDTH   {64}
    set_instance_parameter_value hsb_mipi_holo_shim C_AXIS_TUSER_WIDTH   {1}

    add_interface                i_clk_cpu               clock            sink
    set_interface_property       i_clk_cpu               export_of        cpu_clk_bridge.in_clk

    add_interface                i_rst_cpu               reset            sink
    set_interface_property       i_rst_cpu               export_of        cpu_rst_bridge.in_reset

    add_interface                i_clk_hif               clock            sink
    set_interface_property       i_clk_hif               export_of        hif_clk_bridge.in_clk

    add_interface                i_rst_hif               reset            sink
    set_interface_property       i_rst_hif               export_of        hif_rst_bridge.in_reset

    add_interface                o_rst_hif               reset            source
    set_interface_property       o_rst_hif               export_of        hif_rst_output_bridge.out_reset

    add_interface                o_clk_hif               clock            source
    set_interface_property       o_clk_hif               export_of        hif_clk_output_bridge.out_clk

    add_interface                c_init_done             conduit          INPUT
    set_interface_property       c_init_done             EXPORT_OF        hsb.init_done

    add_interface                i_rst_sys               reset            sink
    set_interface_property       i_rst_sys               EXPORT_OF        hsb.sys_rst

    add_interface                c_ptp                   conduit          INPUT
    set_interface_property       c_ptp                   EXPORT_OF        hsb.ptp

    add_interface                c_sif_event_0           conduit          INPUT
    set_interface_property       c_sif_event_0           EXPORT_OF        hsb.sif_event_0

    add_interface                c_sw_sen_rst_0          conduit          INPUT
    set_interface_property       c_sw_sen_rst_0          EXPORT_OF        hsb.sw_sen_rst_0

    add_interface                c_spi_0                 conduit          INPUT
    set_interface_property       c_spi_0                 EXPORT_OF        hsb.spi_0

    add_interface                c_i2c_0                 conduit          INPUT
    set_interface_property       c_i2c_0                 EXPORT_OF        hsb.i2c_0

    add_interface                c_i2c_1                 conduit          INPUT
    set_interface_property       c_i2c_1                 EXPORT_OF        hsb.i2c_1

    add_interface                c_sw_sys                conduit          INPUT
    set_interface_property       c_sw_sys                EXPORT_OF        hsb.sw_sys

    add_interface                apb_0                   apb              host
    set_interface_property       apb_0                   EXPORT_OF        hsb.apb_0

    add_interface                mm_ctrl_out             avalon           host
    set_interface_property       mm_ctrl_out             EXPORT_OF        hsb_mm_bridge.m0

    add_interface                mipi_s_axis             axi4stream       INPUT
    set_interface_property       mipi_s_axis             EXPORT_OF        hsb_mipi_holo_shim.s_axis

    add_interface                av_sink                 avalon_streaming INPUT
    set_interface_property       av_sink                 EXPORT_OF        hsb_avst_axis_shim.av_sink

    add_interface                av_src                  avalon_streaming OUTPUT
    set_interface_property       av_src                  EXPORT_OF        hsb_axis_avst_shim.av_src

    add_interface                o_rst_sif               reset            source
    set_interface_property       o_rst_sif               EXPORT_OF        hsb.o_sif_rst

    add_interface                o_rst_apb               reset            source
    set_interface_property       o_rst_apb               EXPORT_OF        hsb.o_apb_rst

    add_interface                i_clk_ptp               clock            sink
    set_interface_property       i_clk_ptp               EXPORT_OF        hsb.i_ptp_clk

    add_interface                o_rst_ptp               reset            output
    set_interface_property       o_rst_ptp               EXPORT_OF        hsb.o_ptp_rst

    add_connection       cpu_clk_bridge.out_clk          hsb.i_apb_clk
    add_connection       cpu_rst_bridge.clk              cpu_clk_bridge.out_clk
    add_connection       cpu_clk_bridge.out_clk          cpu_rst_bridge.clk

    add_connection       cpu_clk_bridge.out_clk          hsb_mm_bridge.clk
    add_connection       cpu_rst_bridge.out_reset        hsb_mm_bridge.reset

    add_connection       hif_clk_bridge.out_clk          hsb_avst_axis_shim.clk

    add_connection       hif_clk_bridge.out_clk          hsb_axis_avst_shim.clk

    add_connection       hif_clk_bridge.out_clk          hsb.i_hif_clk

    add_connection       hif_clk_bridge.out_clk          hsb.i_sif_clk

    add_connection       hif_clk_bridge.out_clk          hif_rst_bridge.clk

    add_connection       hif_clk_bridge.out_clk          hif_clk_output_bridge.in_clk
    add_connection       hif_clk_bridge.out_clk          hif_rst_output_bridge.clk

    add_connection       hif_clk_bridge.out_clk          hsb_mipi_holo_shim.axis_aclk
    add_connection       hif_rst_bridge.out_reset        hsb_mipi_holo_shim.axis_aresetn

    add_connection       hif_rst_bridge.out_reset        hsb_avst_axis_shim.resetn
    add_connection       hif_rst_bridge.out_reset        hsb_axis_avst_shim.resetn
    add_connection       hif_rst_bridge.out_reset        hif_rst_output_bridge.in_reset

    add_connection       hsb.apb_0                       hsb_mm_bridge.s0

    add_connection       hsb_mipi_holo_shim.m_axis       hsb.rx_sif_0_axis

    add_connection       hsb.tx_hif_0_axis               hsb_axis_avst_shim.s_axis

    add_connection       hsb_avst_axis_shim.m_axis       hsb.rx_hif_0_axis

    sync_sysinfo_parameters
    save_system
}

# insert the subsystem into the top level Platform designer system, and add interfaces
# to the boundary of the top level qsys system

proc edit_top_level_qsys {} {

    set v_project_name  [get_shell_parameter PROJECT_NAME]
    set v_project_path  [get_shell_parameter PROJECT_PATH]
    set v_instance_name [get_shell_parameter INSTANCE_NAME]

    load_system ${v_project_path}/rtl/${v_project_name}_qsys.qsys

    add_instance  ${v_instance_name}  ${v_instance_name}

    add_interface                ${v_instance_name}_o_rst_apb       reset       OUTPUT
    set_interface_property       ${v_instance_name}_o_rst_apb       EXPORT_OF   ${v_instance_name}.o_rst_apb

    add_interface                ${v_instance_name}_c_sw_sys        conduit     INPUT
    set_interface_property       ${v_instance_name}_c_sw_sys        EXPORT_OF   ${v_instance_name}.c_sw_sys

    add_interface                ${v_instance_name}_c_sif_event_0   conduit     INPUT
    set_interface_property       ${v_instance_name}_c_sif_event_0   EXPORT_OF   ${v_instance_name}.c_sif_event_0

    add_interface                ${v_instance_name}_c_sw_sen_rst_0  conduit     INPUT
    set_interface_property       ${v_instance_name}_c_sw_sen_rst_0  EXPORT_OF   ${v_instance_name}.c_sw_sen_rst_0

    add_interface                ${v_instance_name}_c_spi_0         conduit     INPUT
    set_interface_property       ${v_instance_name}_c_spi_0         EXPORT_OF   ${v_instance_name}.c_spi_0

    add_interface                ${v_instance_name}_c_i2c_0         conduit     INPUT
    set_interface_property       ${v_instance_name}_c_i2c_0         EXPORT_OF   ${v_instance_name}.c_i2c_0

    add_interface                ${v_instance_name}_c_i2c_1         conduit     INPUT
    set_interface_property       ${v_instance_name}_c_i2c_1         EXPORT_OF   ${v_instance_name}.c_i2c_1

    add_interface                ${v_instance_name}_c_init_done     conduit     INPUT
    set_interface_property       ${v_instance_name}_c_init_done     EXPORT_OF   ${v_instance_name}.c_init_done

    add_interface                ${v_instance_name}_i_rst_sys       reset       INPUT
    set_interface_property       ${v_instance_name}_i_rst_sys       EXPORT_OF   ${v_instance_name}.i_rst_sys

    add_interface                ${v_instance_name}_o_rst_hif       reset       OUTPUT
    set_interface_property       ${v_instance_name}_o_rst_hif       EXPORT_OF   ${v_instance_name}.o_rst_hif

    add_interface                ${v_instance_name}_o_clk_hif       clock       OUTPUT
    set_interface_property       ${v_instance_name}_o_clk_hif       EXPORT_OF   ${v_instance_name}.o_clk_hif

    add_interface                ${v_instance_name}_c_ptp           conduit     INPUT
    set_interface_property       ${v_instance_name}_c_ptp           EXPORT_OF   ${v_instance_name}.c_ptp

    sync_sysinfo_parameters
    save_system
}

# enable a subset of subsystem interfaces to be available for auto-connection
# to other subsystems at the top qsys level

proc add_auto_connections {} {

    set v_instance_name      [get_shell_parameter INSTANCE_NAME]

    set v_host_intf_freq     [get_shell_parameter HOST_INTF_CLK_FREQ_MHZ]
    set v_host_intf_freq_hz  [expr int(${v_host_intf_freq} * 1000000)]

    set v_apb_intf_freq      [get_shell_parameter APB_CLK_FREQ_MHZ]
    set v_apb_intf_freq_hz   [expr int(${v_apb_intf_freq} * 1000000)]

    add_auto_connection ${v_instance_name} av_src         av_src
    add_auto_connection ${v_instance_name} av_sink        av_sink

    add_auto_connection ${v_instance_name} i_clk_ptp      ${v_apb_intf_freq_hz}

    add_auto_connection ${v_instance_name} i_clk_cpu      ${v_apb_intf_freq_hz}

    add_auto_connection ${v_instance_name} i_rst_cpu      ${v_apb_intf_freq_hz}

    add_auto_connection ${v_instance_name} i_clk_hif      ${v_host_intf_freq_hz}

    add_auto_connection ${v_instance_name} o_rst_sif      sif_rst
    add_auto_connection ${v_instance_name} i_rst_hif      ${v_host_intf_freq_hz}

    add_auto_connection ${v_instance_name} mm_ctrl_out    mm_ctrl
    add_auto_connection ${v_instance_name} mipi_s_axis    mipi_axis

}

# insert lines of code into the top level hdl file

proc edit_top_v_file {} {

    set v_instance_name    [get_shell_parameter INSTANCE_NAME]

    add_qsys_inst_exports_list ${v_instance_name}_c_spi_0_o_spi_csn            ""
    add_qsys_inst_exports_list ${v_instance_name}_c_spi_0_o_spi_sck            ""
    add_qsys_inst_exports_list ${v_instance_name}_c_spi_0_i_spi_sdio           {"4'b0000"}
    add_qsys_inst_exports_list ${v_instance_name}_c_spi_0_o_spi_sdio           ""
    add_qsys_inst_exports_list ${v_instance_name}_c_spi_0_o_spi_oen            ""

    add_qsys_inst_exports_list ${v_instance_name}_c_i2c_0_i_i2c_scl            i_i2c_0_scl
    add_qsys_inst_exports_list ${v_instance_name}_c_i2c_0_i_i2c_sda            i_i2c_0_sda
    add_qsys_inst_exports_list ${v_instance_name}_c_i2c_0_o_i2c_scl_en         o_i2c_0_scl_en
    add_qsys_inst_exports_list ${v_instance_name}_c_i2c_0_o_i2c_sda_en         o_i2c_0_sda_en

    add_qsys_inst_exports_list ${v_instance_name}_c_i2c_1_i_i2c_scl            i_i2c_1_scl
    add_qsys_inst_exports_list ${v_instance_name}_c_i2c_1_i_i2c_sda            i_i2c_1_sda
    add_qsys_inst_exports_list ${v_instance_name}_c_i2c_1_o_i2c_scl_en         o_i2c_1_scl_en
    add_qsys_inst_exports_list ${v_instance_name}_c_i2c_1_o_i2c_sda_en         o_i2c_1_sda_en

    add_qsys_inst_exports_list ${v_instance_name}_c_init_done_o_init_done      ""
    add_qsys_inst_exports_list ${v_instance_name}_i_rst_sys_i_sys_rst          sys_rst
    add_qsys_inst_exports_list ${v_instance_name}_o_rst_hif_reset              sys_rst
    add_qsys_inst_exports_list ${v_instance_name}_c_ptp_o_ptp_sec              ""
    add_qsys_inst_exports_list ${v_instance_name}_c_ptp_o_ptp_nanosec          ""
    add_qsys_inst_exports_list ${v_instance_name}_c_ptp_o_ptp_pps              ""

    add_qsys_inst_exports_list ${v_instance_name}_c_sif_event_0_i_sif_event    {"1'b0"}
    add_qsys_inst_exports_list ${v_instance_name}_c_sw_sen_rst_0_o_sw_sen_rst  ""
    add_qsys_inst_exports_list ${v_instance_name}_c_sw_sys_o_sw_sys_rst        ""

    add_declaration_list wire             ""      "i_i2c_0_scl"
    add_declaration_list wire             ""      "i_i2c_0_sda"
    add_declaration_list wire             ""      "o_i2c_0_scl_en"
    add_declaration_list wire             ""      "o_i2c_0_sda_en"
    add_declaration_list wire             ""      "i_i2c_1_scl"
    add_declaration_list wire             ""      "i_i2c_1_sda"
    add_declaration_list wire             ""      "o_i2c_1_scl_en"
    add_declaration_list wire             ""      "o_i2c_1_sda_en"
    add_declaration_list wire             ""      "sys_rst"

    add_assignments_list "i_i2c_0_scl"            "o_i2c_0_scl_en ? i2c_0_scl : 1'b0"
    add_assignments_list "i_i2c_0_sda"            "o_i2c_0_sda_en ? i2c_0_sda : 1'b0"
    add_assignments_list "i2c_0_scl"              "o_i2c_0_scl_en ? 1'bz : 1'b0"
    add_assignments_list "i2c_0_sda"              "o_i2c_0_sda_en ? 1'bz : 1'b0"
    add_assignments_list "i_i2c_1_scl"            "o_i2c_1_scl_en ? i2c_1_scl : 1'b0"
    add_assignments_list "i_i2c_1_sda"            "o_i2c_1_sda_en ? i2c_1_sda : 1'b0"
    add_assignments_list "i2c_1_scl"              "o_i2c_1_scl_en ? 1'bz : 1'b0"
    add_assignments_list "i2c_1_sda"              "o_i2c_1_sda_en ? 1'bz : 1'b0"

    add_top_port_list inout   ""          "i2c_0_scl"
    add_top_port_list inout   ""          "i2c_0_sda"
    add_top_port_list inout   ""          "i2c_1_scl"
    add_top_port_list inout   ""          "i2c_1_sda"
}

proc evaluate_terp {} {

    set v_project_name  [get_shell_parameter PROJECT_NAME]
    set v_project_path  [get_shell_parameter PROJECT_PATH]

    evaluate_terp_file  ${v_project_path}/quartus/user/hsb.qsf.terp   [list ${v_project_name}] 0 1
}
