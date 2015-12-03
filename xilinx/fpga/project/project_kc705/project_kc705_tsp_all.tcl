
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2014.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7k325tffg900-2
#    set_property BOARD_PART xilinx.com:kc705:part0:1.1 [current_project]


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}


# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set EXT_SYS_CLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 EXT_SYS_CLK ]
  set GPIO [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO ]
  set GPIO2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO2 ]
  set GPIO2_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO2_1 ]
  set GPIO2_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO2_2 ]
  set GPIO_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_1 ]
  set GPIO_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_2 ]
  set GPIO_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_3 ]
  set ddr3_sdram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3_sdram ]

  # Create ports
  set EXT_LEDS [ create_bd_port -dir O -from 7 -to 0 EXT_LEDS ]
  set EXT_PCIE_REFCLK_N [ create_bd_port -dir I EXT_PCIE_REFCLK_N ]
  set EXT_PCIE_REFCLK_P [ create_bd_port -dir I EXT_PCIE_REFCLK_P ]
  set asi_out [ create_bd_port -dir O asi_out ]
  set clk_out1 [ create_bd_port -dir O -type clk clk_out1 ]
  set mpeg_clk [ create_bd_port -dir I mpeg_clk ]
  set mpeg_data [ create_bd_port -dir I -from 7 -to 0 mpeg_data ]
  set mpeg_sync [ create_bd_port -dir I mpeg_sync ]
  set mpeg_valid [ create_bd_port -dir I mpeg_valid ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list CONFIG.POLARITY {ACTIVE_HIGH}  ] $reset

  # Create instance: axi4_tsp_0, and set properties
  set axi4_tsp_0 [ create_bd_cell -type ip -vlnv xiaofei:user:axi4_tsp:1.0 axi4_tsp_0 ]
  set_property -dict [ list CONFIG.C_S00_AXI_ADDR_WIDTH {13} CONFIG.C_S00_AXI_ARUSER_WIDTH {0} CONFIG.C_S00_AXI_AWUSER_WIDTH {0} CONFIG.C_S00_AXI_BUSER_WIDTH {0} CONFIG.C_S00_AXI_RUSER_WIDTH {0} CONFIG.C_S00_AXI_WUSER_WIDTH {0} CONFIG.MONITOR_FILTER_NUM {2} CONFIG.REPLACER_FILTER_NUM {17}  ] $axi4_tsp_0

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0 ]
  set_property -dict [ list CONFIG.C_M_AXI_DATA_WIDTH {64} CONFIG.C_M_AXI_MAX_BURST_LEN {64}  ] $axi_cdma_0

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list CONFIG.c_include_sg {0}  ] $axi_dma_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list CONFIG.C_GPIO2_WIDTH {32} CONFIG.C_GPIO_WIDTH {32} CONFIG.C_INTERRUPT_PRESENT {0} CONFIG.C_IS_DUAL {1}  ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list CONFIG.C_ALL_INPUTS {0} CONFIG.C_GPIO2_WIDTH {16} CONFIG.C_IS_DUAL {1}  ] $axi_gpio_1

  # Create instance: axi_gpio_2, and set properties
  set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2 ]
  set_property -dict [ list CONFIG.C_GPIO2_WIDTH {32} CONFIG.C_IS_DUAL {1}  ] $axi_gpio_2

  # Create instance: axi_gpio_3, and set properties
  set axi_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3 ]
  set_property -dict [ list CONFIG.C_GPIO_WIDTH {9}  ] $axi_gpio_3

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list CONFIG.NUM_MI {11} CONFIG.NUM_SI {5}  ] $axi_interconnect_0

  # Create instance: axi_pcie_0, and set properties
  set axi_pcie_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:2.5 axi_pcie_0 ]
  set_property -dict [ list CONFIG.AXIBAR2PCIEBAR_0 {0x00000000} CONFIG.AXIBAR_AS_0 {true} CONFIG.AXIBAR_AS_1 {true} CONFIG.AXIBAR_AS_2 {true} CONFIG.AXIBAR_AS_3 {true} CONFIG.AXIBAR_NUM {4} CONFIG.BAR0_ENABLED {true} CONFIG.BAR0_SCALE {Kilobytes} CONFIG.BAR0_SIZE {64} CONFIG.BAR0_TYPE {Memory} CONFIG.BAR1_ENABLED {false} CONFIG.BAR_64BIT {true} CONFIG.DEVICE_ID {0x7012} CONFIG.MAX_LINK_SPEED {2.5_GT/s} CONFIG.M_AXI_DATA_WIDTH {64} CONFIG.NO_OF_LANES {X4} CONFIG.PCIEBAR2AXIBAR_0 {0x81000000} CONFIG.PCIE_CAP_SLOT_IMPLEMENTED {true} CONFIG.S_AXI_DATA_WIDTH {64} CONFIG.XLNX_REF_BOARD {None}  ] $axi_pcie_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_0 ]
  set_property -dict [ list CONFIG.Memory_Type {True_Dual_Port_RAM}  ] $blk_mem_gen_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0 ]
  set_property -dict [ list CONFIG.CLKOUT1_JITTER {122.344} CONFIG.CLKOUT1_PHASE_ERROR {97.646} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {135} CONFIG.PRIMITIVE {MMCM}  ] $clk_wiz_0

  # Create instance: intr_hub_0, and set properties
  set intr_hub_0 [ create_bd_cell -type ip -vlnv xiaofei:user:intr_hub:1.0 intr_hub_0 ]
  set_property -dict [ list CONFIG.INT_NUM {3}  ] $intr_hub_0

  # Create instance: kc705_i2s_receiver_0, and set properties
  set kc705_i2s_receiver_0 [ create_bd_cell -type ip -vlnv xiaofei:user:kc705_i2s_receiver:1.0 kc705_i2s_receiver_0 ]
  set_property -dict [ list CONFIG.C_M00_AXIS_START_COUNT {1} CONFIG.I2S_RECEIVER_NUM {32}  ] $kc705_i2s_receiver_0

  # Create instance: kc705_pcie_ext_0, and set properties
  set kc705_pcie_ext_0 [ create_bd_cell -type ip -vlnv xiaofei:user:kc705_pcie_ext:1.0 kc705_pcie_ext_0 ]

  # Create instance: kc705_ts2asi_0, and set properties
  set kc705_ts2asi_0 [ create_bd_cell -type ip -vlnv xiaofei:user:kc705_ts2asi:1.0 kc705_ts2asi_0 ]

  # Create instance: mig_7series_0, and set properties
  set mig_7series_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:2.2 mig_7series_0 ]
  set_property -dict [ list CONFIG.BOARD_MIG_PARAM {ddr3_sdram} CONFIG.RESET_BOARD_INTERFACE {reset}  ] $mig_7series_0

  # Create instance: myip_i2s_sender_0, and set properties
  set myip_i2s_sender_0 [ create_bd_cell -type ip -vlnv xiaofei:user:kc705_i2s_sender:1.0 myip_i2s_sender_0 ]
  set_property -dict [ list CONFIG.I2S_RECEIVER_NUM {32}  ] $myip_i2s_sender_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:1.0 util_vector_logic_0 ]
  set_property -dict [ list CONFIG.C_OPERATION {not} CONFIG.C_SIZE {1}  ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list CONFIG.NUM_PORTS {3}  ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list CONFIG.CONST_VAL {0} CONFIG.CONST_WIDTH {5}  ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_pcie_0/M_AXI]
  connect_bd_intf_net -intf_net SYS_CLK_1 [get_bd_intf_ports EXT_SYS_CLK] [get_bd_intf_pins mig_7series_0/SYS_CLK]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins axi_cdma_0/M_AXI] [get_bd_intf_pins axi_interconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI_SG [get_bd_intf_pins axi_cdma_0/M_AXI_SG] [get_bd_intf_pins axi_interconnect_0/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports GPIO] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO2 [get_bd_intf_ports GPIO2] [get_bd_intf_pins axi_gpio_0/GPIO2]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO [get_bd_intf_ports GPIO_1] [get_bd_intf_pins axi_gpio_1/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO2 [get_bd_intf_ports GPIO2_1] [get_bd_intf_pins axi_gpio_1/GPIO2]
  connect_bd_intf_net -intf_net axi_gpio_2_GPIO [get_bd_intf_ports GPIO_2] [get_bd_intf_pins axi_gpio_2/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_2_GPIO2 [get_bd_intf_ports GPIO2_2] [get_bd_intf_pins axi_gpio_2/GPIO2]
  connect_bd_intf_net -intf_net axi_gpio_3_GPIO [get_bd_intf_ports GPIO_3] [get_bd_intf_pins axi_gpio_3/GPIO]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_pcie_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins axi_pcie_0/S_AXI_CTL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_cdma_0/S_AXI_LITE] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi4_tsp_0/s00_axi] [get_bd_intf_pins axi_interconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins axi_gpio_2/S_AXI] [get_bd_intf_pins axi_interconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins axi_gpio_3/S_AXI] [get_bd_intf_pins axi_interconnect_0/M10_AXI]
  connect_bd_intf_net -intf_net kc705_i2s_receiver_0_m00_axis [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins kc705_i2s_receiver_0/m00_axis]
  connect_bd_intf_net -intf_net mig_7series_0_DDR3 [get_bd_intf_ports ddr3_sdram] [get_bd_intf_pins mig_7series_0/DDR3]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_interconnect_0/M10_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/S02_ARESETN] [get_bd_pins axi_interconnect_0/S03_ARESETN] [get_bd_pins axi_interconnect_0/S04_ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net EXT_PCIE_REFCLK_N_1 [get_bd_ports EXT_PCIE_REFCLK_N] [get_bd_pins kc705_pcie_ext_0/EXT_PCIE_REFCLK_N]
  connect_bd_net -net EXT_PCIE_REFCLK_P_1 [get_bd_ports EXT_PCIE_REFCLK_P] [get_bd_pins kc705_pcie_ext_0/EXT_PCIE_REFCLK_P]
  connect_bd_net -net M05_ARESETN_1 [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net axi4_tsp_0_ts_out [get_bd_pins axi4_tsp_0/ts_out] [get_bd_pins kc705_ts2asi_0/din_8b]
  connect_bd_net -net axi4_tsp_0_ts_out_clk [get_bd_pins axi4_tsp_0/ts_out_clk] [get_bd_pins kc705_ts2asi_0/din_clk]
  connect_bd_net -net axi4_tsp_0_ts_out_valid [get_bd_pins axi4_tsp_0/ts_out_valid] [get_bd_pins kc705_ts2asi_0/valid]
  connect_bd_net -net axi_cdma_0_cdma_introut [get_bd_pins axi_cdma_0/cdma_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_pcie_0_axi_aclk_out [get_bd_pins axi4_tsp_0/s00_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_gpio_2/s_axi_aclk] [get_bd_pins axi_gpio_3/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_interconnect_0/M10_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/S02_ACLK] [get_bd_pins axi_interconnect_0/S03_ACLK] [get_bd_pins axi_interconnect_0/S04_ACLK] [get_bd_pins axi_pcie_0/axi_aclk_out] [get_bd_pins intr_hub_0/clk] [get_bd_pins kc705_i2s_receiver_0/m00_axis_aclk] [get_bd_pins kc705_pcie_ext_0/pcie_clk_125MHz] [get_bd_pins myip_i2s_sender_0/clk]
  connect_bd_net -net axi_pcie_0_axi_ctl_aclk_out [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_pcie_0/axi_ctl_aclk_out]
  connect_bd_net -net axi_pcie_0_mmcm_lock [get_bd_pins axi_pcie_0/mmcm_lock] [get_bd_pins kc705_pcie_ext_0/pcie_mmcm_locked]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports clk_out1] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins kc705_ts2asi_0/clk]
  connect_bd_net -net intr_hub_0_int_o [get_bd_pins axi_pcie_0/INTX_MSI_Request] [get_bd_pins intr_hub_0/int_o]
  connect_bd_net -net kc705_pcie_ext_0_EXT_LEDS [get_bd_ports EXT_LEDS] [get_bd_pins kc705_pcie_ext_0/EXT_LEDS]
  connect_bd_net -net kc705_pcie_ext_0_mmcms_locked [get_bd_pins kc705_pcie_ext_0/mmcms_locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net kc705_pcie_ext_0_pcie_refclk_100MHz [get_bd_pins axi_pcie_0/REFCLK] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins kc705_pcie_ext_0/pcie_refclk_100MHz]
  connect_bd_net -net kc705_ts2asi_0_asi_out [get_bd_ports asi_out] [get_bd_pins kc705_ts2asi_0/asi_out]
  connect_bd_net -net mig_7series_0_init_calib_complete [get_bd_pins kc705_pcie_ext_0/ddr_rdy] [get_bd_pins mig_7series_0/init_calib_complete]
  connect_bd_net -net mig_7series_0_ui_clk [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins kc705_pcie_ext_0/ddr_clk_100MHz] [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst [get_bd_pins kc705_pcie_ext_0/ddr_rst] [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net mpeg_clk_1 [get_bd_ports mpeg_clk] [get_bd_pins axi4_tsp_0/mpeg_clk]
  connect_bd_net -net mpeg_data_1 [get_bd_ports mpeg_data] [get_bd_pins axi4_tsp_0/mpeg_data]
  connect_bd_net -net mpeg_sync_1 [get_bd_ports mpeg_sync] [get_bd_pins axi4_tsp_0/mpeg_sync]
  connect_bd_net -net mpeg_valid_1 [get_bd_ports mpeg_valid] [get_bd_pins axi4_tsp_0/mpeg_valid]
  connect_bd_net -net myip_i2s_sender_0_i2s_sender_bclk [get_bd_pins kc705_i2s_receiver_0/i2s_receiver_bclk] [get_bd_pins myip_i2s_sender_0/i2s_sender_bclk]
  connect_bd_net -net myip_i2s_sender_0_i2s_sender_lrclk [get_bd_pins kc705_i2s_receiver_0/i2s_receiver_lrclk] [get_bd_pins myip_i2s_sender_0/i2s_sender_lrclk]
  connect_bd_net -net myip_i2s_sender_0_i2s_sender_sdata [get_bd_pins kc705_i2s_receiver_0/i2s_receiver_sdata] [get_bd_pins myip_i2s_sender_0/i2s_sender_sdata]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi4_tsp_0/s00_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_gpio_2/s_axi_aresetn] [get_bd_pins axi_gpio_3/s_axi_aresetn] [get_bd_pins axi_pcie_0/axi_aresetn] [get_bd_pins intr_hub_0/rst] [get_bd_pins kc705_i2s_receiver_0/m00_axis_aresetn] [get_bd_pins kc705_ts2asi_0/rst_n] [get_bd_pins mig_7series_0/aresetn] [get_bd_pins myip_i2s_sender_0/rst_n] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins clk_wiz_0/reset] [get_bd_pins proc_sys_reset_0/peripheral_reset]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins kc705_pcie_ext_0/EXT_SYS_RST] [get_bd_pins mig_7series_0/sys_rst] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins intr_hub_0/int_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins axi_pcie_0/MSI_Vector_Num] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x1000 -offset 0x81003000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x10000 -offset 0x80020000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR2] SEG_axi_pcie_0_BAR2
  create_bd_addr_seg -range 0x10000 -offset 0x80020000 [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR2] SEG_axi_pcie_0_BAR2
  create_bd_addr_seg -range 0x10000 -offset 0x80030000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR3] SEG_axi_pcie_0_BAR3
  create_bd_addr_seg -range 0x10000 -offset 0x80030000 [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR3] SEG_axi_pcie_0_BAR3
  create_bd_addr_seg -range 0x1000 -offset 0x81000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_pcie_0/S_AXI_CTL/CTL0] SEG_axi_pcie_0_CTL0
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x10000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  create_bd_addr_seg -range 0x10000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  create_bd_addr_seg -range 0x10000 -offset 0x80010000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR1] SEG_axi_pcie_0_BAR1
  create_bd_addr_seg -range 0x10000 -offset 0x80010000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR1] SEG_axi_pcie_0_BAR1
  create_bd_addr_seg -range 0x1000 -offset 0x81004000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi4_tsp_0/s00_axi/reg0] SEG_axi4_tsp_0_reg0
  create_bd_addr_seg -range 0x1000 -offset 0x81003000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x1000 -offset 0x81002000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] SEG_axi_cdma_0_Reg
  create_bd_addr_seg -range 0x1000 -offset 0x81001000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x1000 -offset 0x81005000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x1000 -offset 0x81006000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x1000 -offset 0x81007000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_gpio_2/S_AXI/Reg] SEG_axi_gpio_2_Reg
  create_bd_addr_seg -range 0x1000 -offset 0x81008000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_gpio_3/S_AXI/Reg] SEG_axi_gpio_3_Reg
  create_bd_addr_seg -range 0x1000 -offset 0x81000000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_pcie_0/S_AXI_CTL/CTL0] SEG_axi_pcie_0_CTL0
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


