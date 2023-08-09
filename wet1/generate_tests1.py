#!/usr/bin/env python3
import numpy as np
import functools
import random
import os

NUM_TEST = 16
REP_NUM = 7
# MAX_NUM_QUAD = (2**64)-1

intro = ".global _start\n\n  .section .text\n\n"
exits = "  movq $60, %rax\n  movq $0, %rdi\n  syscall\n\n"
exits += "bad_exit:\n  movq $60, %rax\n  movq $1, %rdi\n  syscall\n\n"

f_test = open(f'./ex1/ex1test1', 'w')

data = ".section .data\n"
cmps = "  mov $Bool, %rax\n"

data += f"  num: .quad 0\n"
data += "  Bool: .byte 0"

cmps += f"  cmpb $0, (%rax)\n"
cmps += "  jne bad_exit\n"
cmps += "\n"

f_test.write(intro + cmps + exits + data + "\n\n")

f_test.close()

for m in range(REP_NUM):
    for i in range(0, NUM_TEST):
        f_test = open(f'./ex1/ex1test{NUM_TEST*m+i+2}', 'w')

        data = ".section .data\n"
        cmps = "  mov $Bool, %rax\n"

        start = 2**(4*i)
        end = 2**(4*(i+1))-1
        # print(start)
        # print(end)
        num = random.randint(start, end-1)

        data += f"  num: .quad {str(hex(num))}\n"
        data += "  Bool: .byte 0"

        count = 0
        for j in str(bin(num)):
            if j == "1":
                count += 1

        cmps += f"  cmpb ${count}, (%rax)\n"
        cmps += "  jne bad_exit\n"
        cmps += "\n"

        f_test.write(intro + cmps + exits + data + "\n\n")

        f_test.close()
