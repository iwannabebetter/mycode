# Sys Clock Pins
set_property PACKAGE_PIN AD12 [get_ports EXT_SYS_CLK_P]
set_property PACKAGE_PIN AD11 [get_ports EXT_SYS_CLK_N]
set_property IOSTANDARD DIFF_SSTL15 [get_ports EXT_SYS_CLK_P]
set_property IOSTANDARD DIFF_SSTL15 [get_ports EXT_SYS_CLK_N]
# Sys Reset Pins
set_property PACKAGE_PIN AB7 [get_ports EXT_SYS_RST]
set_property IOSTANDARD LVCMOS15 [get_ports EXT_SYS_RST]

# PCIe Refclk Pins
set_property PACKAGE_PIN U8 [get_ports EXT_PCIE_REFCLK_P]
set_property PACKAGE_PIN U7 [get_ports EXT_PCIE_REFCLK_N]
# PCIe TX RX Pins
set_property PACKAGE_PIN M6 [get_ports {EXT_PCIE_rxp[0]}]
set_property PACKAGE_PIN M5 [get_ports {EXT_PCIE_rxn[0]}]
set_property PACKAGE_PIN P6 [get_ports {EXT_PCIE_rxp[1]}]
set_property PACKAGE_PIN P5 [get_ports {EXT_PCIE_rxn[1]}]
set_property PACKAGE_PIN R4 [get_ports {EXT_PCIE_rxp[2]}]
set_property PACKAGE_PIN R3 [get_ports {EXT_PCIE_rxn[2]}]
set_property PACKAGE_PIN T6 [get_ports {EXT_PCIE_rxp[3]}]
set_property PACKAGE_PIN T5 [get_ports {EXT_PCIE_rxn[3]}]
set_property PACKAGE_PIN L4 [get_ports {EXT_PCIE_txp[0]}]
set_property PACKAGE_PIN L3 [get_ports {EXT_PCIE_txn[0]}]
set_property PACKAGE_PIN M2 [get_ports {EXT_PCIE_txp[1]}]
set_property PACKAGE_PIN M1 [get_ports {EXT_PCIE_txn[1]}]
set_property PACKAGE_PIN N4 [get_ports {EXT_PCIE_txp[2]}]
set_property PACKAGE_PIN N3 [get_ports {EXT_PCIE_txn[2]}]
set_property PACKAGE_PIN P2 [get_ports {EXT_PCIE_txp[3]}]
set_property PACKAGE_PIN P1 [get_ports {EXT_PCIE_txn[3]}]

# LED Pins
set_property PACKAGE_PIN AB8 [get_ports {EXT_LEDS[0]}]
set_property PACKAGE_PIN AA8 [get_ports {EXT_LEDS[1]}]
set_property PACKAGE_PIN AC9 [get_ports {EXT_LEDS[2]}]
set_property PACKAGE_PIN AB9 [get_ports {EXT_LEDS[3]}]
set_property PACKAGE_PIN AE26 [get_ports {EXT_LEDS[4]}]
set_property PACKAGE_PIN G19 [get_ports {EXT_LEDS[5]}]
set_property PACKAGE_PIN E18 [get_ports {EXT_LEDS[6]}]
set_property PACKAGE_PIN F16 [get_ports {EXT_LEDS[7]}]
set_property IOSTANDARD LVCMOS15 [get_ports {EXT_LEDS[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {EXT_LEDS[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {EXT_LEDS[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {EXT_LEDS[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {EXT_LEDS[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {EXT_LEDS[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {EXT_LEDS[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {EXT_LEDS[7]}]

#create_clock -period 10.000 -name ext_pcie_refclk -waveform {0.000 5.000} [get_pins pcie_refclk_buf/O]
#create_clock -period 10.000 -name int_pcie_refclk -waveform {0.000 5.000} [get_nets design_1_i/pcie_cdma_subsystem/axi_pcie_1/design_1_axi_pcie_1_0/inst/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/gt_top_i/pipe_wrapper_i/pipe_clock_i/refclk]
#create_clock -period 5.000 -name ext_sys_clk -waveform {0.000 2.500} [get_ports EXT_SYS_CLK_P]
#set_false_path -through [get_nets {design_1_i/axi_peripheral_aresetn}]
#set_false_path -through [get_nets {design_1_i/axi_interconnect_aresetn}]
#set_false_path -to [get_pins design_1_i/pcie_cdma_subsystem/axi_pcie_1/design_1_axi_pcie_1_0/inst/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/gt_top_i/pipe_wrapper_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/S*]
#set_case_analysis 1 [get_pins {design_1_i/pcie_cdma_subsystem/axi_pcie_1/design_1_axi_pcie_1_0/inst/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/gt_top_i/pipe_wrapper_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/S0}]
#set_case_analysis 0 [get_pins {design_1_i/pcie_cdma_subsystem/axi_pcie_1/design_1_axi_pcie_1_0/inst/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/gt_top_i/pipe_wrapper_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/S1}]

#set_property LOC PCIE_X0Y0 [get_cells design_1_i/pcie_cdma_subsystem/axi_pcie_1/design_1_axi_pcie_1_0/inst/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/pcie_top_i/pcie_7x_i/pcie_block_i]

#set_property DCI_CASCADE {32 34} [get_iobanks 33]
