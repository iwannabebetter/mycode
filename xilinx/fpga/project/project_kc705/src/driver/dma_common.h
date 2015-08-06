#ifndef _DMA_COMMON_H
#define _DMA_COMMON_H

#include <linux/version.h>

int wait_for_iostatus_timeout(unsigned long count, uint8_t *paddr, uint32_t mask, uint32_t expection);
int write_addr_to_reg(uint32_t *reg, uint64_t addr);
void prepare_test_data(uint8_t *tx_memory, int tx_size, uint8_t *rx_memory, int rx_size);
void test_result(uint8_t *tx_memory, int tx_size, uint8_t *rx_memory, int rx_size);


#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
irqreturn_t isr(int irq, void *dev_id, struct pt_regs *regs);
#else
irqreturn_t isr(int irq, void *dev_id);
#endif
int dma_worker_thread(void *ppara);

#endif //#define _DMA_COMMON_H
