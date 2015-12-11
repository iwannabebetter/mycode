#ifndef _PCIE_H
#define _PCIE_H

#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/mutex.h>

#include "utils/xiaofei_debug.h"
#include "utils/xiaofei_timer.h"
#include "utils/xiaofei_kthread.h"
#include "utils/xiaofei_list_buffer.h"


/** @name Macros for PCI probing
 * @{
 */
#define PCI_VENDOR_ID_DMA   0x10EE      /**< Vendor ID - Xilinx */
#define PCI_DEVICE_ID_DMA   0x7012      /**< Xilinx's Device ID */

//Base Address
//regs
#define BASE_AXI_PCIe 0x81000000
#define BASE_AXI_PCIe_CTL 0x81000000
#define BASE_AXI_TSP_LITE 0x81001000
#define BASE_AXI_GPIO_LITE_0 0x81002000
#define BASE_AXI_GPIO_LITE_1 0x81003000
#define BASE_AXI_GPIO_LITE_2 0x81004000
#define BASE_AXI_GPIO_LITE_3 0x81005000
#define BASE_AXI_DMA_LITE_0 0x81006000
#define BASE_AXI_DMA_LITE_1 0x81007000
#define BASE_AXI_DMA_LITE_2 0x81008000
#define BASE_Translation_BRAM 0x81009000

//memory
#define BASE_AXI_DDR_ADDR 0x00000000
#define BASE_AXI_PCIe_BAR0 0x80000000
#define BASE_AXI_PCIe_BAR1 0x80010000
#define BASE_AXI_PCIe_BAR2 0x80020000
//#define BASE_AXI_PCIe_BAR3 0x80030000

//PCIe:BAR0 Address Offset for the accessible Interfaces
#define OFFSET_AXI_PCIe_CTL (BASE_AXI_PCIe_CTL - BASE_AXI_PCIe)
#define OFFSET_AXI_TSP_LITE (BASE_AXI_TSP_LITE - BASE_AXI_PCIe)
#define OFFSET_AXI_GPIO_LITE_0 (BASE_AXI_GPIO_LITE_0 - BASE_AXI_PCIe)
#define OFFSET_AXI_GPIO_LITE_1 (BASE_AXI_GPIO_LITE_1 - BASE_AXI_PCIe)
#define OFFSET_AXI_GPIO_LITE_2 (BASE_AXI_GPIO_LITE_2 - BASE_AXI_PCIe)
#define OFFSET_AXI_GPIO_LITE_3 (BASE_AXI_GPIO_LITE_3 - BASE_AXI_PCIe)
#define OFFSET_AXI_DMA_LITE_0 (BASE_AXI_DMA_LITE_0 - BASE_AXI_PCIe)
#define OFFSET_AXI_DMA_LITE_1 (BASE_AXI_DMA_LITE_1 - BASE_AXI_PCIe)
#define OFFSET_AXI_DMA_LITE_2 (BASE_AXI_DMA_LITE_2 - BASE_AXI_PCIe)
#define OFFSET_Translation_BRAM (BASE_Translation_BRAM - BASE_AXI_PCIe)

//Address Map for the AXI to PCIe Address Translation Registers
#define AXIBAR2PCIEBAR_0U 0x208 //default be set to 0
#define AXIBAR2PCIEBAR_0L 0x20c //default be set to 0xa0000000
#define AXIBAR2PCIEBAR_1U 0x210 //default be set to 0
#define AXIBAR2PCIEBAR_1L 0x214 //default be set to 0xc0000000
#define AXIBAR2PCIEBAR_2U 0x218 //
#define AXIBAR2PCIEBAR_2L 0x21c //
#define AXIBAR2PCIEBAR_3U 0x220 //
#define AXIBAR2PCIEBAR_3L 0x224 //
#define AXIBAR2PCIEBAR_4U 0x228 //
#define AXIBAR2PCIEBAR_4L 0x22c //
#define AXIBAR2PCIEBAR_5U 0x230 //
#define AXIBAR2PCIEBAR_5L 0x234 //

#define PCIe_MAP_BAR_SIZE 0x10000

/**< Maximum number of BARs */
#define MAX_BARS 6
/**< Maximum number of MAX_BAR_MAP_MEMORY */
#define MAX_BAR_MAP_MEMORY 256

#define DMA_BLOCK_SIZE 0x1000

typedef enum {
	AXI_DMA = 0,
	AXI_CDMA,
	PSEUDO_DMA,
} dma_type_t;

typedef irqreturn_t (*process_isr_t)(void *ppara);
typedef int (*init_dma_t)(void *ppara);
typedef int (*dma_tr_t)(void *ppara);

typedef struct _dma_op {
	init_dma_t init_dma;
	process_isr_t process_isr; 
	dma_tr_t dma_tr; 
} dma_op_t;

typedef struct {
	void *kc705_pci_dev;
	int bar_map_memory_num;
	int bar_map_memory_size[MAX_BAR_MAP_MEMORY];
	void *bar_map_memory[MAX_BAR_MAP_MEMORY];
	dma_addr_t bar_map_addr[MAX_BAR_MAP_MEMORY];
	int dma_lite_offset;
	int pcie_bar_map_ctl_offset_0;
	int pcie_bar_map_ctl_offset_1;
	int pcie_map_bar_axi_addr_0;
	int pcie_map_bar_axi_addr_1;
	int dma_bar_map_num;
	list_buffer_t *list;
	uint64_t target_axi_addr_base;
	dma_type_t dma_type;
	dma_op_t dma_op;
	struct completion tx_cmp;
	struct completion rx_cmp;
	long unsigned int tx_count;
	long unsigned int rx_count;

	struct cdev cdev;
	char dev_name[16];
	wait_queue_head_t wq;
	dev_t pcie_dma_dev_id;
	struct class *pcie_dma_class;
	struct device *device;
} pcie_dma_t;

typedef struct {
	pcie_dma_t *dma;
	uint64_t tx_dest_axi_addr;
	uint64_t rx_src_axi_addr;
	int tx_size;
	int rx_size;
	uint8_t *tx_data;
	uint8_t *rx_data;
	struct completion *tr_cmp;
} pcie_tr_t;

typedef struct {
	struct pci_dev *pdev; /**< PCI device entry */
	u32 bar_mask;                    /**< Bitmask for BAR information */
	struct {
		unsigned long base_phyaddr; /**< Base address of device memory */
		unsigned long base_len; /**< Length of device memory */
		void __iomem * base_vaddr; /**< VA - mapped address */
	} bar_info[MAX_BARS];
	int msi_enable;
	struct work_struct work;
	pcie_dma_t *dma;
	void **gpiochip;
	struct task_struct *pcie_tr_thread;
	struct task_struct *test_thread[10];
	timer_data_t *ptimer_data;
	list_buffer_t *pcie_tr_list;
	spinlock_t alloc_lock;

	struct cdev cdev;
	char dev_name[16];
	dev_t kc705_dev_id;
	struct class *kc705_class;
	struct device *device;
} kc705_pci_dev_t;

#endif //#define _PCIE_H
