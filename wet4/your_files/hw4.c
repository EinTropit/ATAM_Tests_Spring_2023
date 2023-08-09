#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <signal.h>
#include <syscall.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/reg.h>
#include <sys/user.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdbool.h>

#include "elf64.h"

#define	ET_NONE	0	//No file type 
#define	ET_REL	1	//Relocatable file 
#define	ET_EXEC	2	//Executable file 
#define	ET_DYN	3	//Shared object file 
#define	ET_CORE	4	//Core file 

#define SHT_SYMTAB 2
#define SHT_STRTAB 3
#define STB_GLOBAL 1
#define GENERAL_FAIL -5

size_t fpread(void *buffer, size_t size, size_t mitems, size_t offset, FILE *fp)
{
     if (fseek(fp, offset, SEEK_SET) != 0)
         return 0;
     return fread(buffer, size, mitems, fp);
}

/* symbol_name		- The symbol (maybe function) we need to search for.
 * exe_file_name	- The file where we search the symbol in.
 * error_val		- If  1: A global symbol was found, and defined in the given executable.
 * 			- If -1: Symbol not found.
 *			- If -2: Only a local symbol was found.
 * 			- If -3: File is not an executable.
 * 			- If -4: The symbol was found, it is global, but it is not defined in the executable.
 * return value		- The address which the symbol_name will be loaded to, if the symbol was found and is global.
 */
unsigned long find_symbol(char* symbol_name, char* exe_file_name, int* error_val) {
	
	Elf64_Ehdr ELFHeader;
	FILE* elfFile = fopen(exe_file_name, "r");
	
	if(!elfFile)
	{
		*error_val = GENERAL_FAIL;
		printf("err2\n");
		return 0;
	}

	fread(&ELFHeader, sizeof(Elf64_Ehdr), 1, elfFile);

	if(ELFHeader.e_type != ET_EXEC)
	{
		fclose(elfFile);
		*error_val = -3;
		return 0;
	}

	char *buffer = (char*)malloc(sizeof(char) * 16);
	int shdr_Amount = ELFHeader.e_shnum;
	int symtab_idx = -1, strtab_idx = -1, dynsym_idx = -1, rel_idx = -1, dynstr_idx = -1;
	Elf64_Shdr *sectionHeaders = (Elf64_Shdr*) malloc(sizeof(Elf64_Shdr) * shdr_Amount);
	fpread(sectionHeaders, sizeof(Elf64_Shdr), shdr_Amount, ELFHeader.e_shoff, elfFile);
	for(int i = 0; i < shdr_Amount; i++)
	{
		fpread(buffer ,sizeof(char) , 16, sectionHeaders[ELFHeader.e_shstrndx].sh_offset + sectionHeaders[i].sh_name, elfFile);
		if(strcmp(buffer, ".symtab") == 0)
			symtab_idx = i;
		else if(strcmp(buffer, ".strtab") == 0)
			strtab_idx = i;
		else if(strcmp(buffer, ".dynsym") == 0)
			dynsym_idx = i;
		else if(strcmp(buffer, ".rela.plt") == 0)
			rel_idx = i;
		else if(strcmp(buffer, ".dynstr") == 0)
			dynstr_idx = i;
	}
	if(strtab_idx == -1 || symtab_idx == -1)
	{
		fclose(elfFile);
		*error_val = GENERAL_FAIL;
		printf("err1\n");
		return 0;
	}
	free(buffer);
	Elf64_Shdr symtab = sectionHeaders[symtab_idx];
	Elf64_Shdr strtab = sectionHeaders[strtab_idx];
	free(sectionHeaders);
	int symtab_entry_amount = symtab.sh_size / symtab.sh_entsize;

	int found = 0;
	Elf64_Sym symbol_entry;
	buffer = (char*)malloc(sizeof(char) * (strlen(symbol_name) + 1));
	for(int i = 0; i < symtab_entry_amount; i++)
	{
		fpread(&symbol_entry, sizeof(Elf64_Sym), 1, symtab.sh_offset + i * sizeof(Elf64_Sym), elfFile);
		fpread(buffer ,sizeof(char) , strlen(symbol_name) + 1, strtab.sh_offset + symbol_entry.st_name, elfFile);
		if(strcmp(symbol_name, buffer) == 0)
		{
			found = 1;
			if(ELF64_ST_BIND(symbol_entry.st_info) == STB_GLOBAL)
			{
				found = 2;
				if(symbol_entry.st_shndx != SHN_UNDEF)
				{
					found = 3;
					break;
				}
			}
		}
	} 
	free(buffer);

	if(found == 0)
	{
		fclose(elfFile);
		*error_val = -1;
		return 0;
	}
	else if(found == 1)
	{
		fclose(elfFile);
		*error_val = -2;
		return 0;
	}
	else if(found == 2)
	{
		*error_val = -4;
		// return 0;
		if (dynsym_idx == -1 || rel_idx == -1 || dynstr_idx == -1)
		{
			fclose(elfFile);
			*error_val = GENERAL_FAIL;
			printf("err1\n");
			return 0;
		}
		Elf64_Shdr *sectionHeaders = (Elf64_Shdr*) malloc(sizeof(Elf64_Shdr) * shdr_Amount);
		fpread(sectionHeaders, sizeof(Elf64_Shdr), shdr_Amount, ELFHeader.e_shoff, elfFile);
		Elf64_Shdr dynsym = sectionHeaders[dynsym_idx];
		Elf64_Shdr rel = sectionHeaders[rel_idx];
		Elf64_Shdr dynstr = sectionHeaders[dynstr_idx];
		free(sectionHeaders);
		int rel_entry_amount = rel.sh_size / rel.sh_entsize;
		Elf64_Rela rel_entry;
		Elf64_Sym dynsym_entry;
		int sym_idx = -1;
		buffer = (char*)malloc(sizeof(char) * (strlen(symbol_name) + 1));
		for(int i = 0; i < rel_entry_amount; i++)
		{
			fpread(&rel_entry, sizeof(Elf64_Rela), 1, rel.sh_offset + i * sizeof(Elf64_Rela), elfFile);
			sym_idx = ELF64_R_SYM(rel_entry.r_info);
			//printf("idx: %d\n", sym_idx);
			fpread(&dynsym_entry, sizeof(Elf64_Sym), 1, dynsym.sh_offset + sym_idx * sizeof(Elf64_Sym), elfFile);
			//printf("name: %x\n", dynsym_entry.st_name);
			fpread(buffer ,sizeof(char) , strlen(symbol_name) + 1, dynstr.sh_offset + dynsym_entry.st_name, elfFile);
			//printf("%s\n", buffer);
			if(strcmp(symbol_name, buffer) == 0)
			{
				free(buffer);
				fclose(elfFile);
				return rel_entry.r_offset;
			}
		}
		fclose(elfFile);
		return 0;
	}

	*error_val = 1;
	fclose(elfFile);
	return symbol_entry.st_value;
}

pid_t run_target(char *const argv[])
{
	pid_t pid;
	pid = fork();

	if (pid > 0)
	{
		return pid;
	}
	else if (pid == 0)
	{
		if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) < 0)
		{
			perror("ptrace");
			exit(1);
		}
		execv(argv[2], argv+2);
		perror("exec");
		exit(1);
	} 
	else
	{
		perror("fork");
		exit(1);
	}
}

void run_debugger(pid_t child_pid, char *const argv[])
{
	int wait_status;
	struct user_regs_struct regs;

	wait(&wait_status);

	int err = 0;
	unsigned long GOT_addr = 0;
	unsigned long long ret_rsp = -1;
	unsigned long addr = find_symbol(argv[1], argv[2], &err);

    if (err == -4)  // part4->2
	{
		GOT_addr = addr;
		addr = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)GOT_addr, NULL);
    }

	int call_counter = 1;
	unsigned long data = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)addr, NULL);

	unsigned long data_trap = (data & 0xFFFFFFFFFFFFFF00) | 0xCC;
	ptrace(PTRACE_POKETEXT, child_pid, (void*)addr, (void*)data_trap);

	ptrace(PTRACE_CONT, child_pid, NULL, NULL);

	wait(&wait_status);
	while(!WIFEXITED(wait_status))
	{
		ptrace(PTRACE_GETREGS, child_pid, NULL, &regs);	

		ptrace(PTRACE_POKETEXT, child_pid, (void*)addr, (void*)data);
		regs.rip -= 1;
		ret_rsp = regs.rsp;
		unsigned long ret_addr = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)regs.rsp, NULL);
		printf("PRF:: run #%d first parameter is %d\n", call_counter, (int)regs.rdi);
		ptrace(PTRACE_SETREGS, child_pid, NULL, &regs);	

		unsigned long ret_data = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)ret_addr, NULL);

		unsigned long ret_data_trap = (ret_data & 0xFFFFFFFFFFFFFF00) | 0xCC;
		ptrace(PTRACE_POKETEXT, child_pid, (void*)ret_addr, (void*)ret_data_trap);

		ptrace(PTRACE_CONT, child_pid, NULL, NULL);

		wait(&wait_status);
		ptrace(PTRACE_GETREGS, child_pid, NULL, &regs);	
		while (ret_rsp >= regs.rsp)
		{
			ptrace(PTRACE_POKETEXT, child_pid, (void*)ret_addr, (void*)ret_data);
			regs.rip -= 1;
			ptrace(PTRACE_SETREGS, child_pid, NULL, &regs);	
			ptrace(PTRACE_SINGLESTEP, child_pid, NULL, NULL);
			wait(&wait_status);
			ptrace(PTRACE_POKETEXT, child_pid, (void*)ret_addr, (void*)ret_data_trap);
			ptrace(PTRACE_CONT, child_pid, NULL, NULL);
			wait(&wait_status);
			ptrace(PTRACE_GETREGS, child_pid, NULL, &regs);	
		}
		

		ptrace(PTRACE_POKETEXT, child_pid, (void*)ret_addr, (void*)ret_data);
		regs.rip -= 1;
		printf("PRF:: run #%d returned with %d\n", call_counter, (int)regs.rax);
		ptrace(PTRACE_SETREGS, child_pid, NULL, &regs);	

		if (err == -4 && call_counter == 1)
		{
			addr = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)GOT_addr, NULL);
			data = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)addr, NULL);

			data_trap = (data & 0xFFFFFFFFFFFFFF00) | 0xCC;
		}

		// ptrace(PTRACE_SINGLESTEP, child_pid, NULL, NULL);

		ptrace(PTRACE_POKETEXT, child_pid, (void*)addr, (void*)data_trap);
		ptrace(PTRACE_CONT, child_pid, NULL, NULL);

		wait(&wait_status);
		call_counter++;
	}
	

}

int main(int argc, char *const argv[]) {
	int err = 0;
	unsigned long GOT_addr = 0;
	unsigned long addr = find_symbol(argv[1], argv[2], &err);
	//printf("addr = %lu     err = %d\n", addr, err);
    if (err == -3)
    {
		printf("PRF:: %s not an executable!\n", argv[2]);
        return 0;
    }
    else if (err == -1)
    {
		printf("PRF:: %s not found! :(\n", argv[1]);
        return 0;
    }
    else if (err == -2)
    {
		printf("%s is not a global symbol!\n", argv[1]);
        return 0;
    }

	pid_t child_pid;
	child_pid = run_target(argv);

	run_debugger(child_pid, argv);

	

	return 0;
}