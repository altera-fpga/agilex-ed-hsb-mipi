# Holoscan Sensor Bridge MIPI to 10GbE System Example Design for Agilex™ 5 Devices

## Overview

This projects contains the necessary files and collateral to create and build the Holoscan Sensor Bridge MIPI to 10GbE System Example Design for Agilex™ 5 Devices.

The products of this project are generated :

|Product|Type|Description|
|:-----:|:-----:|:-----:|
|.sof|SRAM Object File|FPGA bitstream to be loaded over JTAG

</br>

### License Requirements

Free licenses for MIPI D-Phy IP, MIPI CSI-2 IP, and must be downloaded and installed.

nVidia Holoscan IP core must be downloaded and installed.

## Hardware Flow

The Hardware flow uses the Modular Design Toolkit (MDT) to create and build the Quartus® projects Holoscan Sensor Bridge MIPI to 10GbE System Example Design for Agilex™ 5 Devices.

### Software Requirements

The MDT requires the following linux versions of software tools:

- Quartus® Prime Pro 25.1 with Agilex™ 5 E-Series support.

## Creating and compiling Holoscan Sensor Bridge MIPI to 10GbE System Example Design

### Create the design using the Modular Design Toolkit (MDT)

Follow the next steps to create the Quartus® and Platform Designer Project for the Holoscan Sensor Bridge MIPI to 10GbE System Example Design:

- Create your workspace and clone the repository using `--recurse-submodules`:

```bash
cd <workspace>
git clone -b rel-25.1-2507-4 --recurse-submodules https://github.com/altera-fpga/agilex-ed-hsb-mipi.git
```

- Download and unzip the NVIDIA Holoscan Sensor Bridge IP

> [!IMPORTANT]
> Before downloading nv_hsb_ip, refer to the license agreement located at <https://edge.urm.nvidia.com/artifactory/sw-holoscan-thirdparty-generic-local/hsb/fpga_ip/2507>. Ensure that you have read and understood the terms and conditions outlined in the license file.

```bash
# Download HSB IP
curl -SL -o nv_hsb_ip.zip https://edge.urm.nvidia.com/artifactory/sw-holoscan-thirdparty-generic-local/hsb/fpga_ip/2507/nv_hsb_ip.zip

# Extract into MDT workspace
unzip -qq nv_hsb_ip.zip -d agilex-ed-hsb-mipi/a5e065b-mod-devkit/subsystems/hsb_subsystem/non_qpds_ip/pd_hsb_ip 
```

- Define a `<project>` location of your choice, creating directory structure where necessary.
- Navigate to the `agilex-ed-hsb-mipi/a5e065b-mod-devkit` directory containing the cloned repository and create your project, selecting the XML variant for the project.

```bash
cd agilex-ed-hsb-mipi/a5e065b-mod-devkit/designs
quartus_sh -t ../modular-design-toolkit/scripts/create/create_shell.tcl -proj_path <project> -proj_name AGX_5E_065B_Modular_DevKit_HSB_MIPI_1_10GbE -xml_path ./AGX_5E_065B_Modular_DevKit_HSB_MIPI_1_10GbE.xml
```

This will create your Quartus® Prime and Platform Designer Project in `<project>`. The folder structure is consistent with the MDT methodology.

#### Building the design using the Modular Design Toolkit (MDT)

Follow the next steps to build the Holoscan Sensor Bridge MIPI to 10GbE System Example Design:

- Navigate to the `<project>/scripts` directory and build your project:

```bash
quartus_sh -t build_shell.tcl -hw_compile
```

The FPGA programming file is located in the `<project>/quartus/output_files` directory:

- SOF MDT Flow:
  - `AGX_5E_065B_Modular_DevKit_HSB_MIPI_1_10GbE.sof`
