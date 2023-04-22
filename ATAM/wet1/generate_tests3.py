#!/usr/bin/env python3
import numpy as np
import functools
import random
import os

NUM_TEST = 20
REP_NUM = 5

MAX_ARR_SIZE = 50
MAX_ARR_DATA = 100

intro = ".global _start\n\n  .section .text\n\n"
exits = "  movq $60, %rax\n  movq $0, %rdi\n  syscall\n\n"
exits += "bad_exit:\n  movq $60, %rax\n  movq $1, %rdi\n  syscall\n\n"

negTest = False
for m in range(REP_NUM):
    for i in range(0, NUM_TEST):
        f_test = open(f'./ex3/ex3test{NUM_TEST*m+i+1}', 'w')

        data = ".section .data\n"
        cmps = "  mov $mergedArray, %rax\n"

        size1 = random.randint(1, MAX_ARR_SIZE)
        size2 = random.randint(1, MAX_ARR_SIZE)

        array1 = []
        array2 = []

        for j in range(size1):
            x = random.randint(1, MAX_ARR_DATA)
            array1.append(x)
        for j in range(size2):
            x = random.randint(1, MAX_ARR_DATA)
            array2.append(x)

        array1.sort(reverse=True)
        array2.sort(reverse=True)
        merged = array1 + array2
        merged.sort(reverse=True)
        merged = list(dict.fromkeys(merged))
        merged.append(0)

        data += "  array1: .int "
        for x in array1:
            data += f"{x},"
        data += "0\n"
        data += "  array2: .int "
        for x in array2:
            data += f"{x},"
        data += "0\n"
        data += f"  mergedArray: .zero {len(merged)}"

        for j in range(len(merged)):
            cmps += f"  cmpl ${merged[j]}, {4*j}(%rax)\n"
            cmps += "  jne bad_exit\n"

        cmps += "\n"

        f_test.write(intro + cmps + exits + data + "\n\n")

        f_test.close()
