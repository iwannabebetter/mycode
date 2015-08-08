#include <linux/module.h>
#include <linux/pci.h>
#include <linux/interrupt.h>

#include "utils/xiaofei_debug.h"
#include "utils/xiaofei_timer.h"
#include "utils/xiaofei_kthread.h"

#include "kc705.h"
#include "pcie.h"
#include "dma_common.h"
#include "pcie_device.h"

/**
 * Macro to export pci_device_id to user space to allow hot plug and
 * module loading system to know what module works with which hardware device
 */
MODULE_DEVICE_TABLE(pci, ids);

/** PCI device structure which probes for targeted design */
static struct pci_device_id ids[] = {
	{
		PCI_VENDOR_ID_DMA,
		PCI_DEVICE_ID_DMA,
		PCI_ANY_ID,
		PCI_ANY_ID,
		0,
		0,
		0UL
	},
	{}     /* terminate list with empty entry */
};

static kc705_pci_dev_t *kc705_pci_dev = NULL;
static DEFINE_MUTEX(work_lock);
static timer_data_t *ptimer_data = NULL;
static struct task_struct *thread = NULL;

static void read_pci_configuration(struct pci_dev * pdev) {
	int i;
	u8 valb;
	u16 valw;
	u32 valdw;
	unsigned long reg_base, reg_len;

	/* Read PCI configuration space */
	printk(KERN_INFO "PCI Configuration Space:\n");
	for(i=0; i<0x40; i++)
	{
		pci_read_config_byte(pdev, i, &valb);
		printk("0x%x ", valb);
		if((i % 0x10) == 0xf) printk("\n");
	}
	printk("\n");

	/* Now read each element - one at a time */

	/* Read Vendor ID */
	pci_read_config_word(pdev, PCI_VENDOR_ID, &valw);
	printk("Vendor ID: 0x%x, ", valw);

	/* Read Device ID */
	pci_read_config_word(pdev, PCI_DEVICE_ID, &valw);
	printk("Device ID: 0x%x, ", valw);

	/* Read Command Register */
	pci_read_config_word(pdev, PCI_COMMAND, &valw);
	printk("Cmd Reg: 0x%x, ", valw);

	/* Read Status Register */
	pci_read_config_word(pdev, PCI_STATUS, &valw);
	printk("Stat Reg: 0x%x, ", valw);

	/* Read Revision ID */
	pci_read_config_byte(pdev, PCI_REVISION_ID, &valb);
	printk("Revision ID: 0x%x, ", valb);

	/* Read Class Code */
	/*
	   pci_read_config_dword(pdev, PCI_CLASS_PROG, &valdw);
	   printk("Class Code: 0x%lx, ", valdw);
	   valdw &= 0x00ffffff;
	   printk("Class Code: 0x%lx, ", valdw);
	 */
	/* Read Reg-level Programming Interface */
	pci_read_config_byte(pdev, PCI_CLASS_PROG, &valb);
	printk("Class Prog: 0x%x, ", valb);

	/* Read Device Class */
	pci_read_config_word(pdev, PCI_CLASS_DEVICE, &valw);
	printk("Device Class: 0x%x, ", valw);

	/* Read Cache Line */
	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &valb);
	printk("Cache Line Size: 0x%x, ", valb);

	/* Read Latency Timer */
	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &valb);
	printk("Latency Timer: 0x%x, ", valb);

	/* Read Header Type */
	pci_read_config_byte(pdev, PCI_HEADER_TYPE, &valb);
	printk("Header Type: 0x%x, ", valb);

	/* Read BIST */
	pci_read_config_byte(pdev, PCI_BIST, &valb);
	printk("BIST: 0x%x\n", valb);

	/* Read all 6 BAR registers */
	for(i=0; i<=5; i++)
	{
		/* Physical address & length */
		reg_base = pci_resource_start(pdev, i);
		reg_len = pci_resource_len(pdev, i);
		printk("BAR%d: Addr:0x%lx Len:0x%lx,  ", i, reg_base, reg_len);

		/* Flags */
		if((pci_resource_flags(pdev, i) & IORESOURCE_MEM)) {
			printk("Region is for memory\n");
		} else if((pci_resource_flags(pdev, i) & IORESOURCE_IO)) {
			printk("Region is for I/O\n");
		}
	}
	printk("\n");

	/* Read CIS Pointer */
	pci_read_config_dword(pdev, PCI_CARDBUS_CIS, &valdw);
	printk("CardBus CIS Pointer: 0x%x, ", valdw);

	/* Read Subsystem Vendor ID */
	pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &valw);
	printk("Subsystem Vendor ID: 0x%x, ", valw);

	/* Read Subsystem Device ID */
	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &valw);
	printk("Subsystem Device ID: 0x%x\n", valw);

	/* Read Expansion ROM Base Address */
	pci_read_config_dword(pdev, PCI_ROM_ADDRESS, &valdw);
	printk("Expansion ROM Base Address: 0x%x\n", valdw);

	/* Read IRQ Line */
	pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, &valb);
	printk("IRQ Line: 0x%x, ", valb);

	/* Read IRQ Pin */
	pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &valb);
	printk("IRQ Pin: 0x%x, ", valb);

	/* Read Min Gnt */
	pci_read_config_byte(pdev, PCI_MIN_GNT, &valb);
	printk("Min Gnt: 0x%x, ", valb);

	/* Read Max Lat */
	pci_read_config_byte(pdev, PCI_MAX_LAT, &valb);
	printk("Max Lat: 0x%x\n", valb);
}

static void read_pci_root_configuration(struct pci_dev * pdev) {
	int i;
	u8 valb;
	struct pci_bus * parent;
	struct pci_bus * me;

	/* Read PCI configuration space for all devices on this bus */
	parent = pdev->bus->parent;
	for(i=0; i<256; i++)
	{
		pci_bus_read_config_byte(parent, 8, i, &valb);
		printk("%02x ", valb);
		if(!((i+1) % 16)) printk("\n");
	}

	printk("Device %p details:\n", pdev);
	printk("Bus_list %p\n", &(pdev->bus_list));
	printk("Bus %p\n", pdev->bus);
	printk("Subordinate %p\n", pdev->subordinate);
	printk("Sysdata %p\n", pdev->sysdata);
	printk("Procent %p\n", pdev->procent);
	printk("Devfn %d\n", pdev->devfn);
	printk("Vendor %x\n", pdev->vendor);
	printk("Device %x\n", pdev->device);
	printk("Subsystem_vendor %x\n", pdev->subsystem_vendor);
	printk("Subsystem_device %x\n", pdev->subsystem_device);
	printk("Class %d\n", pdev->class);
	printk("Hdr_type %d\n", pdev->hdr_type);
	printk("Rom_base_reg %d\n", pdev->rom_base_reg);
	printk("Pin %d\n", pdev->pin);
	printk("Driver %p\n", pdev->driver);
	printk("Dma_mask %lx\n", (unsigned long)(pdev->dma_mask));
	printk("Vendor_compatible: ");
	//for(i=0; i<DEVICE_COUNT_COMPATIBLE; i++)
	//  printk("%x ", pdev->vendor_compatible[i]);
	//printk("\n");
	//printk("Device_compatible: ");
	//for(i=0; i<DEVICE_COUNT_COMPATIBLE; i++)
	//  printk("%x ", pdev->device_compatible[i]);
	//printk("\n");
	printk("Cfg_size %d\n", pdev->cfg_size);
	printk("Irq %d\n", pdev->irq);
	printk("Transparent %d\n", pdev->transparent);
	printk("Multifunction %d\n", pdev->multifunction);
	//printk("Is_enabled %d\n", pdev->is_enabled);
	printk("Is_busmaster %d\n", pdev->is_busmaster);
	printk("No_msi %d\n", pdev->no_msi);
	printk("No_dld2 %d\n", pdev->no_d1d2);
	printk("Block_ucfg_access %d\n", pdev->block_cfg_access);
	printk("Broken_parity_status %d\n", pdev->broken_parity_status);
	printk("Msi_enabled %d\n", pdev->msi_enabled);
	printk("Msix_enabled %d\n", pdev->msix_enabled);
	printk("Rom_attr_enabled %d\n", pdev->rom_attr_enabled);

	me = pdev->bus;
	printk("Bus details:\n");
	printk("Parent %p\n", me->parent);
	printk("Children %p\n", &(me->children));
	printk("Devices %p\n", &(me->devices));
	printk("Self %p\n", me->self);
	printk("Sysdata %p\n", me->sysdata);
	printk("Procdir %p\n", me->procdir);
	printk("Number %d\n", me->number);
	printk("Primary %d\n", me->primary);
//	printk("Secondary %d\n", me->secondary);
//	printk("Subordinate %d\n", me->subordinate);
	printk("Name %s\n", me->name);
	printk("Bridge_ctl %d\n", me->bridge_ctl);
	printk("Bridge %p\n", (void *)me->bridge);
}

void dump_regs(uint8_t *reg_addr, int size) {
	int i;
	uint8_t *base_vaddr = reg_addr;

	for(i = 0; i < size; i += sizeof(uint32_t)) {
		if((i != 0) && (i % (8 * sizeof(uint32_t)) == 0)) {
			printk("\n");
		}
		printk("%08x(@0x%03x) ", readl(base_vaddr + i), i);
	}

	printk("\n");
}

void dump_memory(void *addr, int size) {
	uint8_t *memory = (uint8_t *)addr;
	int i;

	printk("addr:0x%p\n", addr);
	for(i = 0; i < size; i++) {
		if((i != 0) && (i % (8 * sizeof(uint32_t)) == 0)) {
			printk("\n");
		}
		printk("%02x ", memory[i]);
	}

	printk("\n");
}

static uint64_t dma_op_count = 0;
static struct timeval start_time = {0};

void inc_dma_op_count(void) {
	dma_op_count++;
}

static void test_performance(void) {
	struct timeval stop_time;

	do_gettimeofday(&stop_time);

	//mydebug("dma_op_count:%ld\n", dma_op_count);
	//mydebug("stop_time.tv_sec:%lu\n", stop_time.tv_sec);
	//mydebug("start_time.tv_sec:%lu\n", start_time.tv_sec);
	//mydebug("stop_time.tv_usec:%lu\n", stop_time.tv_usec);
	//mydebug("start_time.tv_usec:%lu\n", start_time.tv_usec);

	printk("DMA speed: %u.%06uMB/s\n", (unsigned int)(dma_op_count * DM_CHANNEL_TX_SIZE) / (1024 * 1024), (unsigned int)((dma_op_count * DM_CHANNEL_TX_SIZE) % (1024 * 1024)) * (1000 * 1000) / (1024 * 1024));

	dma_op_count = 0;
	do_gettimeofday(&start_time);
}

static void work_func(struct work_struct *work) {
	kc705_pci_dev_t *kc705_pci_dev = container_of(work, kc705_pci_dev_t, work);

	mutex_lock(&work_lock);
	kc705_pci_dev = kc705_pci_dev;
	test_performance();
	mutex_unlock(&work_lock);
}

static void timer_func(unsigned long __opaque) {
	timer_data_t *ptimer_data = (timer_data_t *)__opaque;
	unsigned long tmo = msecs_to_jiffies(ptimer_data->ms);
	struct timer_list *tl = ptimer_data->tl;

	schedule_work(&(kc705_pci_dev->work));
	tl->expires = jiffies + tmo;
	add_timer(tl);
}

static int start_work_loop(void) {
	INIT_WORK(&(kc705_pci_dev->work), work_func);

	ptimer_data = alloc_timer(1000, timer_func);

	thread = alloc_work_thread(dma_worker_thread, kc705_pci_dev, "%s", "pcie_thread");

	setup_kc705_dev(kc705_pci_dev);
	return 0;
}

static void end_work_loop(void) {
	uninstall_kc705_dev(kc705_pci_dev);

	if(thread != NULL) {
		free_work_thread(thread);
	}

	if(ptimer_data != NULL) {
		free_timer(ptimer_data);
	}
}

static int kc705_probe_pcie(struct pci_dev *pdev, const struct pci_device_id *ent) {
	int rtn = 0;
	int i;

	//alloc memory for driver
	kc705_pci_dev = (kc705_pci_dev_t *)vzalloc(sizeof(kc705_pci_dev_t));
	if(kc705_pci_dev == NULL) {
		mydebug("alloc kc705_pci_dev failed.\n");
		rtn = -1;
		goto alloc_kc705_pci_dev_failed;
	}


	kc705_pci_dev->list = init_list_buffer();
	if(kc705_pci_dev->list == NULL) {
		rtn = -1;
		goto init_list_buffer_failed;
	}

	kc705_pci_dev->bar_map_memory_size[0] = 0;
	kc705_pci_dev->bar_map_memory_size[1] = AXI_PCIe_BAR1_SIZE;
	kc705_pci_dev->bar_map_memory_size[2] = AXI_PCIe_BAR1_SIZE;
	kc705_pci_dev->bar_map_memory_size[3] = AXI_PCIe_BAR1_SIZE;
	//alloc memory for cdma
	for(i = 0; i < MAX_BARS; i++) {
		if(kc705_pci_dev->bar_map_memory_size[i] != 0) {
			kc705_pci_dev->bar_map_memory[i] = dma_zalloc_coherent(&(pdev->dev), kc705_pci_dev->bar_map_memory_size[i], &(kc705_pci_dev->bar_map_addr[i]), GFP_KERNEL);
			if(kc705_pci_dev->bar_map_memory[i] == NULL) {
				rtn = -1;
				mydebug("dma_zalloc_coherent failed.\n");
				goto pci_enable_device_failed;
			} else {
				mydebug("kc705_pci_dev->bar_map_memory[%d]:%p\n", i, kc705_pci_dev->bar_map_memory[i]);
				mydebug("kc705_pci_dev->bar_map_addr[%d]:%p\n", i, (void *)kc705_pci_dev->bar_map_addr[i]);
				mydebug("kc705_pci_dev->bar_map_memory_size[%d]:%x\n", i, kc705_pci_dev->bar_map_memory_size[i]);
				if(i > 1) {
					add_list_buffer_item((char *)kc705_pci_dev->bar_map_memory[i], (void *)kc705_pci_dev->bar_map_addr[i], kc705_pci_dev->bar_map_memory_size[i], kc705_pci_dev->list);
				}
			}
		}
	}

	rtn = pci_enable_device(pdev);
	if(rtn < 0)
	{
		mydebug("PCI device enable failed.\n");
		goto pci_enable_device_failed;
	}


	/*
	 * Enable bus-mastering on device. Calls pcibios_set_master() to do
	 * the needed architecture-specific settings.
	 */
	pci_set_master(pdev);

	/* Reserve PCI I/O and memory resources. Mark all PCI regions
	 * associated with PCI device as being reserved by owner. Do not
	 * access any address inside the PCI regions unless this call returns
	 * successfully.
	 */
	rtn = pci_request_regions(pdev, MODULE_NAME);
	if(rtn < 0) {
		mydebug("Could not request PCI regions.\n");
		goto pci_request_regions_failed;
	}

	for(i = 0; i < MAX_BARS; i++) {

		/* Atleast BAR0 must be there. */
		if((kc705_pci_dev->bar_info[i].base_len = pci_resource_len(pdev, i)) == 0) {
			if(i == 0) {
				mydebug("BAR 0 not valid, aborting.\n");
				goto pci_resource_len_failed;
			} else {
				continue;
			}
		} else {/* Set a bitmask for all the BARs that are present. */
			(kc705_pci_dev->bar_mask) |= ( 1 << i );
		}

		kc705_pci_dev->bar_info[i].base_phyaddr = pci_resource_start(pdev, i);

		/* Check all BARs for memory-mapped or I/O-mapped. The driver is
		 * intended to be memory-mapped.
		 */
		if(!(pci_resource_flags(pdev, i) & IORESOURCE_MEM)) {
			mydebug("BAR %d is of wrong type, aborting.\n", i);
			goto bar_resource_type_failed;
		}

		/* Map bus memory to CPU space. The ioremap may fail if size
		 * requested is too long for kernel to provide as a single chunk
		 * of memory, especially if users are sharing a BAR region. In
		 * such a case, call ioremap for more number of smaller chunks
		 * of memory. Or mapping should be done based on user request
		 * with user size. Neither is being done now - maybe later.
		 */
		if((kc705_pci_dev->bar_info[i].base_vaddr = ioremap((kc705_pci_dev->bar_info[i].base_phyaddr), kc705_pci_dev->bar_info[i].base_len)) == 0UL) {
			mydebug("Cannot map BAR %d space, invalidating.\n", i);
			(kc705_pci_dev->bar_mask) &= ~( 1 << i );
		} else {
			mydebug(
					"[BAR %d] Base PA %p Len %d VA %p\n",
					i,
					(void *)(kc705_pci_dev->bar_info[i].base_phyaddr),
					(u32)(kc705_pci_dev->bar_info[i].base_len),
					(void *)(kc705_pci_dev->bar_info[i].base_vaddr)
			       );
		}
	}

	kc705_pci_dev->pdev = pdev;

	/* Save private data pointer in device structure */
	pci_set_drvdata(pdev, kc705_pci_dev);

	/* Returns success if PCI is capable of 32-bit DMA */
#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,36)
	rtn = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
#else
	rtn = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
#endif
	if(rtn < 0) {
		mydebug("pci_set_dma_mask failed\n");
		goto pci_set_dma_mask_failed;
	}

	/* Now enable interrupts using MSI mode */
	if(!pci_enable_msi(pdev)) {
		mydebug("MSI enabled\n");
		kc705_pci_dev->msi_enable = 1;
	}
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
	rtn = request_irq(pdev->irq, isr, SA_SHIRQ, MODULE_NAME, pdev);
#else
	rtn = request_irq(pdev->irq, isr, IRQF_SHARED, MODULE_NAME, pdev);
#endif
	if(rtn) {
		mydebug("Could not allocate interrupt %d\n", pdev->irq);
		mydebug("Unload driver and try running with polled mode instead\n");
		rtn = 0;
		goto request_irq_failed;
	}

	/* Display PCI configuration space of device. */
	read_pci_configuration(pdev);

	/* Display PCI information on parent. */
	read_pci_root_configuration(pdev);


	start_work_loop();

	return 0;

pci_set_dma_mask_failed:
	pci_release_regions(pdev);
pci_request_regions_failed:
	pci_disable_device(pdev);
pci_enable_device_failed:
	for(i = 0; i < MAX_BARS; i++) {
		if(kc705_pci_dev->bar_map_memory[i] != 0) {
			dma_free_coherent(&(pdev->dev), kc705_pci_dev->bar_map_memory_size[i], kc705_pci_dev->bar_map_memory[i], kc705_pci_dev->bar_map_addr[i]);
		}
	}
	uninit_list_buffer(kc705_pci_dev->list);
	vfree(kc705_pci_dev);
request_irq_failed:
bar_resource_type_failed:
pci_resource_len_failed:
init_list_buffer_failed:
alloc_kc705_pci_dev_failed:
	return rtn;
}

static void kc705_remove_pcie(struct pci_dev *pdev) {
	int i;

	mutex_lock(&work_lock);

	end_work_loop();

	free_irq(pdev->irq, pdev);

	if(kc705_pci_dev->msi_enable) {
		pci_disable_msi(pdev);
	}

	pci_set_drvdata(pdev, NULL);

	for(i = 0; i < MAX_BARS; i++) {
		if((kc705_pci_dev->bar_mask) & ( 1 << i )) {
			iounmap(kc705_pci_dev->bar_info[i].base_vaddr);
		}
	}

	pci_release_regions(pdev);

	pci_disable_device(pdev);

	for(i = 0; i < MAX_BARS; i++) {
		if(kc705_pci_dev->bar_map_memory[i] != 0) {
			dma_free_coherent(&(pdev->dev), kc705_pci_dev->bar_map_memory_size[i], kc705_pci_dev->bar_map_memory[i], kc705_pci_dev->bar_map_addr[i]);
		}
	}

	uninit_list_buffer(kc705_pci_dev->list);
	vfree(kc705_pci_dev);
	mutex_unlock(&work_lock);
}

struct pci_driver kc705_pcie_driver = {
	.name = MODULE_NAME,
	.id_table = ids,
	.probe = kc705_probe_pcie,
	.remove = __devexit_p(kc705_remove_pcie)
};