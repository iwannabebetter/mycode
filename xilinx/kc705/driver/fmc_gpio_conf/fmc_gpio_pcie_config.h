#ifndef _FMC_GPIO_PCIE_CONFIG_H
#define _FMC_GPIO_PCIE_CONFIG_H

//Base Address
//regs
#define BASE_AXI_PCIe_CTL 0x81000000
#define BASE_AXI_GPIO_LITE_0 0x81001000
#define BASE_AXI_GPIO_LITE_1 0x81002000
#define BASE_AXI_GPIO_LITE_2 0x81003000
#define BASE_AXI_GPIO_LITE_3 0x81004000
#define BASE_AXI_DMA_LITE_1 0x81005000
#define BASE_Translation_BRAM 0x81006000

//PCIe:BAR0 Address Offset for the accessible Interfaces
#define OFFSET_AXI_PCIe_CTL (BASE_AXI_PCIe_CTL - BASE_AXI_PCIe)
#define OFFSET_AXI_GPIO_LITE_0 (BASE_AXI_GPIO_LITE_0 - BASE_AXI_PCIe)
#define OFFSET_AXI_GPIO_LITE_1 (BASE_AXI_GPIO_LITE_1 - BASE_AXI_PCIe)
#define OFFSET_AXI_GPIO_LITE_2 (BASE_AXI_GPIO_LITE_2 - BASE_AXI_PCIe)
#define OFFSET_AXI_GPIO_LITE_3 (BASE_AXI_GPIO_LITE_3 - BASE_AXI_PCIe)
#define OFFSET_AXI_DMA_LITE_1 (BASE_AXI_DMA_LITE_1 - BASE_AXI_PCIe)
#define OFFSET_Translation_BRAM (BASE_Translation_BRAM - BASE_AXI_PCIe)

#endif//#ifndef _FMC_GPIO_PCIE_CONFIG_H
