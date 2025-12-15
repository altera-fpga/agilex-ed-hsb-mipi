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

package require -exact qsys 24.3.1
package require altera_terp

set_module_property DESCRIPTION                  "nVidia HoloLink IP"
set_module_property NAME                         nvidia_hololink
set_module_property VERSION                      1.0
set_module_property INTERNAL                     false
set_module_property OPAQUE_ADDRESS_MAP           false
set_module_property GROUP                        "External IP"
set_module_property DISPLAY_NAME                 "nVidia HoloLink IP"
set_module_property AUTHOR                       "Nvidia Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property ELABORATION_CALLBACK         elab_callback
set_module_property VALIDATION_CALLBACK          val_callback

################################################################################
# Create the User interface
################################################################################
proc create_ui { } {

  add_display_item "" "Structure" GROUP
  add_display_item "Structure"  I2C_INST           parameter
  add_display_item "Structure"  SPI_INST           parameter
  add_display_item "Structure"  APB_INST           parameter
  add_display_item "Structure"  GPIO_INST          parameter
  add_display_item "Structure"  SIF_INST           parameter
  add_display_item "Structure"  HIF_INST           parameter
  add_display_item "Structure"  HIF_CLK_FREQ       parameter
  add_display_item "Structure"  PTP_CLK_FREQ       parameter
  add_display_item "Structure"  APB_CLK_FREQ       parameter

  add_parameter           I2C_INST     INTEGER                   4
  set_parameter_property  I2C_INST     DISPLAY_NAME              "I2C Interfaces"
  set_parameter_property  I2C_INST     ALLOWED_RANGES            {"0:4"}
  set_parameter_property  I2C_INST     AFFECTS_ELABORATION       true

  add_parameter           SPI_INST     INTEGER                   2
  set_parameter_property  SPI_INST     DISPLAY_NAME              "SPI Interfaces"
  set_parameter_property  SPI_INST     ALLOWED_RANGES            {"0:2"}
  set_parameter_property  SPI_INST     AFFECTS_ELABORATION       true

  add_parameter           APB_INST     INTEGER                   8
  set_parameter_property  APB_INST     DISPLAY_NAME              "ABP Interfaces"
  set_parameter_property  APB_INST     ALLOWED_RANGES            {"0:8"}
  set_parameter_property  APB_INST     AFFECTS_ELABORATION       true

  add_parameter           GPIO_INST    INTEGER                   16
  set_parameter_property  GPIO_INST    DISPLAY_NAME              "GPIO Interface Width"
  set_parameter_property  GPIO_INST    AFFECTS_ELABORATION       true
  set_parameter_property  GPIO_INST    ALLOWED_RANGES            {"0:16"}

  # Number of Sensor Interfaces
  add_parameter           SIF_INST     INTEGER                   2
  set_parameter_property  SIF_INST     DISPLAY_NAME              "Number of SIF Interfaces"
  set_parameter_property  SIF_INST     ALLOWED_RANGES            {1 2}
  set_parameter_property  SIF_INST     AFFECTS_ELABORATION       true

  # Number of Host Interfaces
  add_parameter           HIF_INST     INTEGER                   2
  set_parameter_property  HIF_INST     DISPLAY_NAME              "Number of HIF Interfaces"
  set_parameter_property  HIF_INST     ALLOWED_RANGES            {1 2}
  set_parameter_property  HIF_INST     AFFECTS_ELABORATION       true

  add_parameter           HIF_CLK_FREQ INTEGER                   150000000
  set_parameter_property  HIF_CLK_FREQ DISPLAY_NAME              "Host Interface Clock Frequency Hz"
  set_parameter_property  HIF_CLK_FREQ AFFECTS_ELABORATION       true

  add_parameter           PTP_CLK_FREQ INTEGER                   100000000
  set_parameter_property  PTP_CLK_FREQ DISPLAY_NAME              "Precision Time Protocl Clock Frequency Hz"
  set_parameter_property  PTP_CLK_FREQ AFFECTS_ELABORATION       true

  add_parameter           APB_CLK_FREQ INTEGER                   150000000
  set_parameter_property  APB_CLK_FREQ DISPLAY_NAME              "APB Interface Clock Frequency Hz"
  set_parameter_property  APB_CLK_FREQ AFFECTS_ELABORATION       true

  add_parameter           DEVICE       string                    "Unknown"
  set_parameter_property  DEVICE       SYSTEM_INFO               {DEVICE}
  set_parameter_property  DEVICE       HDL_PARAMETER             false
  set_parameter_property  DEVICE       VISIBLE                   false

}

################################################################################
# Add fixed IO
################################################################################
proc add_axi4s_interface { busname clk rst {dir slave} {data_width ""} }  {

  if {${dir} == "master"} {
    set master_out "Output"
    set master_in  "Input"
    set direction  "start"
    set pre_i      "o_"
    set pre_o      "i_"
  } else {
    set master_out "Input"
    set master_in  "Output"
    set direction  "end"
    set pre_i      "i_"
    set pre_o      "o_"
  }

  set parameter_busname "C_[string toupper ${busname}]"

  if { ${data_width} == "" } {
    set data_width  ${parameter_busname}_TDATA_WIDTH
  }

  add_interface ${busname} axi4stream ${direction}
  set_interface_property ${busname} associatedClock ${clk}
  set_interface_property ${busname} associatedReset ${rst}

  add_interface_port ${busname} ${pre_i}${busname}_tvalid tvalid ${master_out} 1
  add_interface_port ${busname} ${pre_i}${busname}_tlast  tlast  ${master_out} 1
  add_interface_port ${busname} ${pre_i}${busname}_tdata  tdata  ${master_out} ${data_width}
  add_interface_port ${busname} ${pre_i}${busname}_tkeep  tkeep  ${master_out} [expr ${data_width} / 8]
  add_interface_port ${busname} ${pre_i}${busname}_tuser  tuser  ${master_out} 1
  add_interface_port ${busname} ${pre_o}${busname}_tready tready ${master_in}  1

  set_port_property ${pre_i}${busname}_tuser VHDL_TYPE STD_LOGIC_VECTOR

}

################################################################################
# Add axis bus that doesn't have tkeep
################################################################################
proc add_axi4s_interface_nokeep { busname clk rst {dir slave} {data_width ""} }  {

  if {${dir} == "master"} {
    set master_out "Output"
    set master_in  "Input"
    set direction  "start"
    set pre_i      "o_"
    set pre_o      "i_"
  } else {
    set master_out "Input"
    set master_in  "Output"
    set direction  "end"
    set pre_i      "i_"
    set pre_o      "o_"
  }

  set parameter_busname "C_[string toupper ${busname}]"
  set idwidth 1

  if { ${data_width} == "" } {
    set data_width  ${parameter_busname}_TDATA_WIDTH
  }

  add_interface ${busname} axi4stream ${direction}
  set_interface_property ${busname} associatedClock ${clk}
  set_interface_property ${busname} associatedReset ${rst}

  add_interface_port ${busname} ${pre_i}${busname}_tvalid tvalid ${master_out} 1
  add_interface_port ${busname} ${pre_i}${busname}_tlast  tlast  ${master_out} 1
  add_interface_port ${busname} ${pre_i}${busname}_tdata  tdata  ${master_out} ${data_width}
  add_interface_port ${busname} ${pre_i}${busname}_tuser  tuser  ${master_out} 1
  add_interface_port ${busname} ${pre_o}${busname}_tready tready ${master_in}  1

  set_port_property ${pre_i}${busname}_tuser VHDL_TYPE STD_LOGIC_VECTOR

}


################################################################################
# Add fixed IO
################################################################################
proc add_io { } {

  # Auto Init Done
  add_interface           init_done     conduit         start
  add_interface_port      init_done     o_init_done     o_init_done Output 1

  # System Reset
  add_interface           sys_rst       conduit         start
  add_interface_port      sys_rst       i_sys_rst       i_sys_rst   Input  1

  # New in 2507, PTP clock and reset
  add_interface           i_ptp_clk     clock           end
  add_interface_port      i_ptp_clk     i_ptp_clk       clk         Input  1
  add_interface           o_ptp_rst     reset           start
  set_interface_property  o_ptp_rst     associatedClock i_ptp_clk
  add_interface_port      o_ptp_rst     o_ptp_rst       reset       Output 1

  # PTP Status
  add_interface           ptp           conduit         start
  add_interface_port ptp  o_ptp_sec     o_ptp_sec       Output      48
  add_interface_port ptp  o_ptp_nanosec o_ptp_nanosec   Output      32
  add_interface_port ptp  o_ptp_pps     o_ptp_pps       Output      1
}

################################################################################
# Process Terp Files
################################################################################
proc add_terp { outputName dest_dir {sim 0 } } {

  set file_lst [glob -nocomplain -- -path "./*.sv.terp"]
  foreach file ${file_lst} {
    set filename [file tail [file rootname ${file}]]

    if {${outputName} != ""} {
      set filename "${outputName}.sv"
    }
    add_fileset_file ${dest_dir}${filename} SYSTEM_VERILOG TEXT [terp_file ${file}]
  }
}

################################################################################
# Add Source files
################################################################################
proc add_source_files { outputName } {

  set file_lst [glob -nocomplain -- -path ../nv_hsb_ip/*/*]
  foreach file ${file_lst} {
    set file_string [split ${file} /]
    set file_name [lindex ${file_string} end]
    if {[regexp {.sv$} ${file_name}]} {
      add_fileset_file "rtl/${file_name}" SYSTEM_VERILOG PATH ${file}
    }
    if {[regexp {\.v$} ${file_name}]} {
      add_fileset_file "rtl/${file_name}" SYSTEM_VERILOG PATH ${file}
    }
  }

  add_fileset_file "rtl/HOLOLINK_def.svh" SYSTEM_VERILOG TEXT [terp_file "HOLOLINK_def.svh.terp"]
  add_terp ${outputName} "./"
}

################################################################################
# Elaboration Callback - Create fixed I/O and evaluate widths of signals.
################################################################################
proc elab_callback { } {

  set spi_inst    [get_parameter_value SPI_INST]
  set gpio_inst   [get_parameter_value GPIO_INST]
  set i2c_inst    [get_parameter_value I2C_INST]
  set apb_inst    [get_parameter_value APB_INST]
  set sif_inst    [get_parameter_value SIF_INST]
  set hif_inst    [get_parameter_value HIF_INST]

  # HIF - Host Interfaces
  add_interface          i_hif_clk    clock           end
  add_interface_port     i_hif_clk    i_hif_clk       clk Input    1

  add_interface          o_hif_rst    reset           start
  set_interface_property o_hif_rst    associatedClock i_hif_clk
  add_interface_port     o_hif_rst    o_hif_rst reset Output       1

  for {set inst 0} {${inst} < ${hif_inst}} {incr inst} {
    add_axi4s_interface rx_hif_${inst}_axis i_hif_clk o_hif_rst slave  64
    add_axi4s_interface tx_hif_${inst}_axis i_hif_clk o_hif_rst master 64
  }

  # SIF - Sensor Interfaces
  add_interface          i_sif_clk      clock           end
  add_interface_port     i_sif_clk      i_sif_clk       clk Input    1

  add_interface          o_sif_rst      reset           start
  set_interface_property o_sif_rst      associatedClock i_sif_clk
  add_interface_port     o_sif_rst      o_sif_rst reset Output       1

  for {set inst 0} {${inst} < ${sif_inst}} {incr inst} {
    add_axi4s_interface rx_sif_${inst}_axis  i_sif_clk             o_sif_rst slave     64
    add_axi4s_interface tx_sif_${inst}_axis  i_sif_clk             o_sif_rst master    64

    # SIF Event
    add_interface       sif_event_${inst}    conduit               start
    add_interface_port  sif_event_${inst}    i_sif_event_${inst}   i_sif_event  Input  1

    add_interface       sw_sen_rst_${inst}   conduit               start
    add_interface_port  sw_sen_rst_${inst}   o_sw_sen_rst_${inst}  o_sw_sen_rst Output 1
  }

  for {set inst 0} {${inst} < ${spi_inst}} {incr inst} {
    # SPI Interface
    add_interface      spi_${inst} conduit            start
    add_interface_port spi_${inst} o_spi_${inst}_csn  o_spi_csn   Output 1
    add_interface_port spi_${inst} o_spi_${inst}_sck  o_spi_sck   Output 1
    add_interface_port spi_${inst} i_spi_${inst}_sdio i_spi_sdio  Input  4
    add_interface_port spi_${inst} o_spi_${inst}_sdio o_spi_sdio  Output 4
    add_interface_port spi_${inst} o_spi_${inst}_oen  o_spi_oen   Output 1
  }

  for {set inst 0} {${inst} < ${i2c_inst}} {incr inst} {
    # I2C Interface
    add_interface      i2c_${inst} conduit              start
    add_interface_port i2c_${inst} i_i2c_${inst}_scl    i_i2c_scl    Input  1
    add_interface_port i2c_${inst} i_i2c_${inst}_sda    i_i2c_sda    Input  1
    add_interface_port i2c_${inst} o_i2c_${inst}_scl_en o_i2c_scl_en Output 1
    add_interface_port i2c_${inst} o_i2c_${inst}_sda_en o_i2c_sda_en Output 1
  }

  # GPIO Interface
  add_interface           gpio         conduit         start
  add_interface_port      gpio         o_gpio          o_gpio Output ${gpio_inst}
  add_interface_port      gpio         i_gpio          i_gpio Input  ${gpio_inst}

  # Sensor Reset
  add_interface           sw_sys       conduit         start
  add_interface_port      sw_sys       o_sw_sys_rst    o_sw_sys_rst  Output 1

  # APB Interface
  add_interface           i_apb_clk    clock           end
  add_interface_port      i_apb_clk    i_apb_clk       clk           Input  1
  add_interface           o_apb_rst    reset           start
  set_interface_property  o_apb_rst    associatedClock i_apb_clk
  add_interface_port      o_apb_rst    o_apb_rst       reset         Output 1

  for {set inst 0} {${inst} < ${apb_inst}} {incr inst} {
    add_interface          apb_${inst} apb                      start
    set_interface_property apb_${inst} associatedClock          i_apb_clk
    set_interface_property apb_${inst} associatedReset          o_apb_rst
    add_interface_port     apb_${inst} o_apb_${inst}_psel       psel       Output 1
    add_interface_port     apb_${inst} o_apb_${inst}_penable    penable    Output 1
    add_interface_port     apb_${inst} o_apb_${inst}_paddr      paddr      Output 32
    add_interface_port     apb_${inst} o_apb_${inst}_pwdata     pwdata     Output 32
    add_interface_port     apb_${inst} o_apb_${inst}_pwrite     pwrite     Output 1
    add_interface_port     apb_${inst} i_apb_${inst}_pready     pready     Input  1
    add_interface_port     apb_${inst} i_apb_${inst}_prdata     prdata     Input  32
    add_interface_port     apb_${inst} i_apb_${inst}_pserr      pslverr    Input  1
  }

}

################################################################################
# Validation Callback - Inform user if they have illegal lane mappings
################################################################################
proc val_callback { } {

}

################################################################################
#   Terp any file based on all the parameters the Phy Core has
################################################################################
proc terp_file { src } {

  upvar ed_name    ed_name
  upvar sim        sim
  upvar outputName outputName

  set terp_fd       [open ${src}]
  set terp_contents [read ${terp_fd}]
  close ${terp_fd}

  set params {\
      I2C_INST \
      GPIO_INST \
      SPI_INST \
      APB_INST \
      SIF_INST \
      HIF_INST \
      HIF_CLK_FREQ \
      PTP_CLK_FREQ \
      APB_CLK_FREQ \
    }

    foreach param ${params} {
      set terp_params([string tolower ${param}]) [get_parameter_value ${param}]
    }

    if {[info exists outputName]} {
      set terp_params(output_name) ${outputName}
    }

    return [ altera_terp ${terp_contents} terp_params]
}

add_fileset synth QUARTUS_SYNTH add_source_files

create_ui
add_io
