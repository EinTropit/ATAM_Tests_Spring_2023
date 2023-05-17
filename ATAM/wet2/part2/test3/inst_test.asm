.global _start

.section .data
msg1: .ascii "start|"
endmsg1:
msg2: .ascii "mid\n"
endmsg2:

.section .text

_start:
  movq $1, %rax
  movq $1, %rdi
  leaq msg1, %rsi
  movq $endmsg1-msg1, %rdx
  syscall

  .short 0x240f

  movq $1, %rax
  movq $1, %rdi
  leaq msg2, %rsi
  movq $endmsg2-msg2, %rdx
  syscall

  .short 0x250f

  movq $60, %rax
  syscall
