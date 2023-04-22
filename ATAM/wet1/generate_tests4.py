#!/usr/bin/env python3
import numpy as np
import functools
import random
import os

NUM_TEST = 20
REP_NUM = 5

MAX_ARR_SIZE = 10
MAX_ARR_DATA = 1000

intro = ".global _start\n\n  .section .text\n\n"
exits = "  movq $60, %rax\n  movq $0, %rdi\n  syscall\n\n"
exits += "bad_exit:\n  movq $60, %rax\n  movq $1, %rdi\n  syscall\n\n"

negTest = False
for m in range(REP_NUM):
    for i in range(0, NUM_TEST):
        f_test = open(f'./ex4/ex4test{NUM_TEST*m+i+1}', 'w')

        data = ".section .data\n"
        cmps = ""

        size = random.randint(1, MAX_ARR_SIZE)

        myList = []

        for j in range(size):
            x = random.randint(1, MAX_ARR_DATA)
            myList.append(x)

        source = random.randint(0, len(myList)-1)
        value = random.randint(MAX_ARR_DATA+1, 2*MAX_ARR_DATA)
        idx = -1

        if i >= 3:
            value = random.choice(myList)
            idx = myList.index(value)

        data += "  head: .quad node_0\n"
        for j in range(len(myList)):
            data += f"  node_{j}:\n          .quad {myList[j]}\n"
            if j < len(myList)-1:
                data += f"          .quad node_{j+1}\n"
            else:
                data += "          .quad 0\n"

            # cmps += f"  mov $node_{j}, %rax\n"
            if j == idx:
                cmps += f"  cmpq ${myList[source]}, (node_{j})\n"
            elif (idx >= 0) and (j == source):
                cmps += f"  cmpq ${myList[idx]}, (node_{j})\n"
            else:
                cmps += f"  cmpq ${myList[j]}, (node_{j})\n"
            cmps += "  jne bad_exit\n"

        data += f"  Source: .quad node_{source}\n"
        data += f"  Value: .quad {value}\n"

        cmps += "\n"

        f_test.write(intro + cmps + exits + data + "\n\n")

        f_test.close()
