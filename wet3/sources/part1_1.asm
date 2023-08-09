.global _start
.extern printf

.section .data
    msg: .asciz "Hello world!"
    msg_len: .quad msg_len - msg
    msg2:
.section .text
    _start:
        lea  msg(%rip), %rdi
        mov  msg_len, %rsi
        xor %rax, %rax
        lea  msg2(%rip), %rdi
    exit:
        mov $60, %rax
        mov $0, %rdi
        syscall


