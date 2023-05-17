#include <linux/module.h>
#include <linux/kernel.h>
#include <asm/desc.h>


//
// Global variables
//
#define INVALID_OPCODE 0x06
struct desc_ptr new_idtr = {};
struct desc_ptr old_idtr = {};
void *old_ili_handler = 0;
char message[200] = {};

//
// Externals
//
//	ASM functions
extern void my_ili_handler(void);

//	C functions
extern void my_store_idt(struct desc_ptr* idtr);
extern void my_load_idt(struct desc_ptr* idtr);
extern void my_set_gate_offset(gate_desc *gate, unsigned long addr);
extern unsigned long my_get_gate_offset(gate_desc *gate);

//
// Utility functions
//
void print(char *str) {
	printk(KERN_INFO "ILI: %s\n", str);
}
 
unsigned int what_to_do(unsigned char magic) {
	return magic-37;
}


//
// Module loader
//
int __init init_ko(void){
	gate_desc *old_idt, *new_idt;
	// Display message from the kernel side
	print("Replacing INVALID OPCODE!");

	// Store the old interrupt descriptor table register (IDTR)
	my_store_idt(&old_idtr);
	old_idt = (gate_desc *)old_idtr.address;
	sprintf(message, "old_idt address: %p", (void*)old_idtr.address);
	print(message);
	
	// Store old INVALID OPCODE handler address
	old_ili_handler = (void*)my_get_gate_offset(&old_idt[INVALID_OPCODE]);
	sprintf(message, "old offset: %p", old_ili_handler);
	print(message);
	
	// Allocate a page for new IDT, and copy old IDT over
	if((new_idtr.address = __get_free_page(GFP_KERNEL)) == 0)
		return -1;
	new_idtr.size = old_idtr.size;
	sprintf(message, "new_idt address: %p", (void*)new_idtr.address);
	print(message);
	new_idt = (gate_desc *)new_idtr.address;
	memcpy(new_idt, old_idt, old_idtr.size);
	
	// Replace INVALID OPCODE handler address with my_ili_handler
	my_set_gate_offset(&new_idt[INVALID_OPCODE], (unsigned long)my_ili_handler);
	sprintf(message, "new offset: %p", (void*)my_get_gate_offset(&new_idt[INVALID_OPCODE]));
	print(message);
	
	
	// Swap to the new IDTR
	my_load_idt(&new_idtr);

	return 0;
}

//
// Module unloader
//
void __exit exit_ko(void){
	// Display message
	print("Restoring INVALID OPCODE");

	// Restore the old IDTR
	my_load_idt(&old_idtr);

	// Free the allocated page
	if(new_idtr.address)
		free_page(new_idtr.address);
}

module_init(init_ko);
module_exit(exit_ko);
MODULE_LICENSE("GPL");
