.global _start

.section .data
msg1: .ascii "start\n"
endmsg:

.section .text

_start:
  movq $1, %rax
  movq $1, %rdi
  leaq msg1, %rsi
  movq $endmsg-msg1, %rdx
  syscall

  .byte 0x27 #ILLEGAL!!!

  movq $60, %rax
  syscall
