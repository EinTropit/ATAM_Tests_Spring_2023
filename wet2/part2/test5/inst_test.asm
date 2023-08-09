.global _start

.section .data
msg1: .ascii "bad\n"
endmsg:
msg2: .ascii "good\n"
endmsg2:

.section .text

_start:
  movq $0xeeeeeeeeeeeeeeee, %rax
  movq $0xeeeeeeeeeeeeeeee, %rbx
  movq $0xeeeeeeeeeeeeeeee, %rcx
  movq $0xeeeeeeeeeeeeeeee, %rdx
  movq $0xeeeeeeeeeeeeeeee, %rsi
  movq $0xeeeeeeeeeeeeeeee, %rbp
  movq $0xeeeeeeeeeeeeeeee, %r8
  movq $0xeeeeeeeeeeeeeeee, %r9
  movq $0xeeeeeeeeeeeeeeee, %r10
  movq $0xeeeeeeeeeeeeeeee, %r11
  movq $0xeeeeeeeeeeeeeeee, %r12
  movq $0xeeeeeeeeeeeeeeee, %r13
  movq $0xeeeeeeeeeeeeeeee, %r14
  movq $0xeeeeeeeeeeeeeeee, %r15

  pushq %rax
  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %rsi
  pushq %rbp
  pushq %r8
  pushq %r9
  pushq %r10
  pushq %r11
  pushq %r12
  pushq %r13
  pushq %r14
  pushq %r15

  .byte 0x1e #ILLEGAL!!!

  cmpq (%rsp), %r15
  jne bad
  cmpq 0x8(%rsp), %r14
  jne bad
  cmpq 0x10(%rsp), %r13
  jne bad
  cmpq 0x18(%rsp), %r12
  jne bad
  cmpq 0x20(%rsp), %r11
  jne bad
  cmpq 0x28(%rsp), %r10
  jne bad
  cmpq 0x30(%rsp), %r9
  jne bad
  cmpq 0x38(%rsp), %r8
  jne bad
  cmpq 0x40(%rsp), %rbp
  jne bad
  cmpq 0x48(%rsp), %rsi
  jne bad
  cmpq 0x50(%rsp), %rdx
  jne bad
  cmpq 0x58(%rsp), %rcx
  jne bad
  cmpq 0x60(%rsp), %rbx
  jne bad
  cmpq 0x68(%rsp), %rax
  jne bad
  
  movq $1, %rax
  movq $1, %rdi
  leaq msg2, %rsi
  movq $endmsg2-msg2, %rdx
  syscall
  jmp endit

bad:
  movq $1, %rax
  movq $1, %rdi
  leaq msg1, %rsi
  movq $endmsg-msg1, %rdx
  syscall

endit:
  movq $60, %rax
  syscall
