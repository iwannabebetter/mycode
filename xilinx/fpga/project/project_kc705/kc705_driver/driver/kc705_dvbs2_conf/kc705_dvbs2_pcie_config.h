#ifndef _KC705_DVBS2_PCIE_CONFIG_H
#define _KC705_DVBS2_PCIE_CONFIG_H

//Base Address
//regs
#define BASE_AXI_PCIe_CTL 0x81000000
#define BASE_AXI_TSP_LITE 0x81001000
#define BASE_AXI_KC705_DVBS2_0 0x81002000
#define BASE_AXI_GPIO_LITE_0 0x81003000
#define BASE_AXI_DMA_LITE_0 0x81004000
#define BASE_AXI_DMA_LITE_1 0x81005000
#define BASE_Translation_BRAM 0x81009000

//PCIe:BAR0 Address Offset for the accessible Interfaces
#define OFFSET_AXI_PCIe_CTL (BASE_AXI_PCIe_CTL - BASE_AXI_PCIe)
#define OFFSET_AXI_TSP_LITE (BASE_AXI_TSP_LITE - BASE_AXI_PCIe)
#define OFFSET_AXI_KC705_DVBS2_0 (BASE_AXI_KC705_DVBS2_0 - BASE_AXI_PCIe)
#define OFFSET_AXI_GPIO_LITE_0 (BASE_AXI_GPIO_LITE_0 - BASE_AXI_PCIe)
#define OFFSET_AXI_DMA_LITE_0 (BASE_AXI_DMA_LITE_0 - BASE_AXI_PCIe)
#define OFFSET_AXI_DMA_LITE_1 (BASE_AXI_DMA_LITE_1 - BASE_AXI_PCIe)
#define OFFSET_Translation_BRAM (BASE_Translation_BRAM - BASE_AXI_PCIe)

#endif//#ifndef _KC705_DVBS2_PCIE_CONFIG_H
