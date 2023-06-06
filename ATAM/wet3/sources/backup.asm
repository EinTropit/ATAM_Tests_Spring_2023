.global _start
.global _hw3_unicorn

.section .data
    msg: .asciz "Hello world!"
    msg_len: .quad msg_len - msg
.section .text
    _start:
        mov $60, %rax
        mov $1, %rdi
        syscall
    _hw3_unicorn:
        mov $60, %rax
        mov $0, %rdi
        syscall


