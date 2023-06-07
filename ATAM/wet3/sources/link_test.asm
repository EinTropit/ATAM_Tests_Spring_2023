section .data
msg1:	db "Tony",4

section .rodata
msg2:	db "Noam",4


section .text
    global _start
    global _hw3_unicorn
    
    _start:
        mov rax, 60
        mov rdi, 1
        syscall
    _hw3_unicorn:
        mov rax, 60
        mov rdi, 0
        syscall


