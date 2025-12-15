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

# create script specific parameters and default values

set_shell_parameter CLK_FREQ_MHZ    "100"

# resolve interdependencies
proc derive_parameters {param_array} {

    set v_clk_freq_mhz [get_shell_parameter CLK_FREQ_MHZ]
    set v_clk_freq_hz  [expr int(${v_clk_freq_mhz} * 1000000)]

    set_shell_parameter DRV_CLK_FREQ_HZ ${v_clk_freq_hz}

}

# define the procedures used by the create_subsystems_qsys.tcl script

proc pre_creation_step {} {

    transfer_files
}

proc creation_step {} {

    create_reset_sync_subsystem
}

proc post_creation_step {} {

    edit_top_level_qsys
    add_auto_connections
    edit_top_v_file
}

# copy files from the shell install directory to the target project directory
proc transfer_files {} {

    set v_project_path      [get_shell_parameter PROJECT_PATH]
    set v_script_path       [get_shell_parameter SUBSYSTEM_SOURCE_PATH]

    file_copy   ${v_script_path}/non_qpds_ip/intel_vip_reset_sync_block     ${v_project_path}/non_qpds_ip/user
    file_copy   ${v_script_path}/non_qpds_ip/reset_sync.ipx                 ${v_project_path}/non_qpds_ip/user

}

# create the reset subsystem, add the required IP, parameterize it as appropriate,
# add internal connections, and add interfaces to the boundary of the subsystem
proc create_reset_sync_subsystem {} {

    set v_project_path              [get_shell_parameter PROJECT_PATH]
    set v_instance_name             [get_shell_parameter INSTANCE_NAME]
    set v_family                    [get_shell_parameter FAMILY]
    set v_project_path              [get_shell_parameter PROJECT_PATH]
    set v_instance_name             [get_shell_parameter INSTANCE_NAME]
    set v_clk_freq_hz               [get_shell_parameter DRV_CLK_FREQ_HZ]

    create_system ${v_instance_name}
		
    save_system   ${v_project_path}/rtl/user/${v_instance_name}.qsys
    load_system   ${v_project_path}/rtl/user/${v_instance_name}.qsys

    # create instances

    add_instance                    input_rst_bridge  altera_reset_bridge
    set_instance_parameter_value    input_rst_bridge  ACTIVE_LOW_RESET        {0}
    set_instance_parameter_value    input_rst_bridge  SYNCHRONOUS_EDGES       none
    set_instance_parameter_value    input_rst_bridge  NUM_RESET_OUTPUTS       {1}
    set_instance_parameter_value    input_rst_bridge  USE_RESET_REQUEST       {0}
    set_instance_parameter_value    input_rst_bridge  SYNC_RESET              {0}

    add_instance input_clk_bridge   altera_clock_bridge
    add_instance reset_sync         intel_vip_reset_sync_block

    # Set Parameters
    set_instance_parameter_value    reset_sync        GEN_OUT_CLK             {1}
    set_instance_parameter_value    reset_sync        ASYNC_RESET             {1}
    set_instance_parameter_value    reset_sync        INPUT_CLOCK_FREQUENCY   ${v_clk_freq_hz}
    set_instance_parameter_value    reset_sync        SYNC_DEPTH              {3}
    set_instance_parameter_value    reset_sync        ADDITIONAL_DEPTH        {2}
    set_instance_parameter_value    reset_sync        DISABLE_GLOBAL_NETWORK  {1}

    # Create Connections
    add_connection  input_clk_bridge.out_clk           reset_sync.clock_in
    add_connection  input_rst_bridge.out_reset         reset_sync.reset_in

    add_interface                i_rst_0    reset       sink
    set_interface_property       i_rst_0    export_of   input_rst_bridge.in_reset

    add_interface                i_clk_0    clock       sink
    set_interface_property       i_clk_0    export_of   input_clk_bridge.in_clk

    add_interface                o_rst_0    reset       source
    set_interface_property       o_rst_0    export_of   reset_sync.reset_out

    add_interface                o_clk_0    reset       source
    set_interface_property       o_clk_0    export_of   reset_sync.clock_out

    sync_sysinfo_parameters
    save_system

}

# insert the subsystem into the top level Platform Designer system, and add interfaces
# to the boundary of the top level Platform Designer system

proc edit_top_level_qsys {} {

    set v_project_name  [get_shell_parameter PROJECT_NAME]
    set v_project_path  [get_shell_parameter PROJECT_PATH]
    set v_instance_name [get_shell_parameter INSTANCE_NAME]

    load_system ${v_project_path}/rtl/${v_project_name}_qsys.qsys

    add_instance  ${v_instance_name}  ${v_instance_name}

    sync_sysinfo_parameters
    save_system

}

# enable a subset of subsystem interfaces to be available for auto-connection
# to other subsystems at the top level Platform Designer system

proc add_auto_connections {} {

    set v_instance_name   [get_shell_parameter INSTANCE_NAME]
    set v_clk_freq_hz     [get_shell_parameter "DRV_CLK_FREQ_HZ"]

    add_auto_connection   ${v_instance_name}  i_rst_0         board_rst
    add_auto_connection   ${v_instance_name}  i_clk_0         ref_clk
    add_auto_connection   ${v_instance_name}  o_clk_0         ${v_clk_freq_hz}
    add_auto_connection   ${v_instance_name}  o_rst_0         ${v_clk_freq_hz}

}

# insert lines of code into the top level hdl file
proc edit_top_v_file {} {

}

proc evaluate_terp {} {

}
