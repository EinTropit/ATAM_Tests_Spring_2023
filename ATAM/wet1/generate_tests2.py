#!/usr/bin/env python3
import numpy as np
import functools
import random
import os

NUM_TEST = 20
REP_NUM = 5

MAX_ARR_SIZE = 50
MAX_ARR_DATA = 255

intro = ".global _start\n\n  .section .text\n\n"
exits = "  movq $60, %rax\n  movq $0, %rdi\n  syscall\n\n"
exits += "bad_exit:\n  movq $60, %rax\n  movq $1, %rdi\n  syscall\n\n"

negTest = False
for m in range(REP_NUM):
    for i in range(0, NUM_TEST):
        f_test = open(f'./ex2/ex2test{NUM_TEST*m+i+1}', 'w')

        data = ".section .data\n"
        cmps = "  mov $destination, %rax\n"

        endTest = random.randint(1, 10)
        if i < 5:
            num = random.randint(-MAX_ARR_DATA, 1)
            data += f"  num: .int {num}\n"
            data += "  source: .byte 0\n"
            data += "  destination: .zero 4\n"
            data += f"               .byte {endTest}\n"

            cmps += f"  cmpl ${num}, (%rax)\n"
            cmps += "  jne bad_exit\n"
            cmps += f"  cmpb ${endTest}, 4(%rax)\n"
            cmps += "  jne bad_exit\n"
        else:
            num = random.randint(0, MAX_ARR_SIZE)
            data += f"  num: .int {num}\n"
            source = []
            data += "  source: .byte "
            for j in range(num):
                x = random.randint(0, MAX_ARR_DATA)
                # source.append(x)
                data += f"{x},"
                cmps += f"  cmpb ${x}, {j}(%rax)\n"
                cmps += "  jne bad_exit\n"

            data += "0\n"
            data += "  destination:\n"
            if not num == 0:
                data += f"              .zero {num}\n"
            data += f"              .byte {endTest}\n"
            cmps += f"  cmpb ${endTest}, {num}(%rax)\n"
            cmps += "  jne bad_exit\n"

        cmps += "\n"

        f_test.write(intro + cmps + exits + data + "\n\n")

        f_test.close()
