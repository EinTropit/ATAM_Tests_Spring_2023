#!/usr/bin/env python3
import numpy as np
import functools
import random
import os

NUM_TEST = 20
REP_NUM = 5

MAX_ARR_SIZE = 50
MAX_ARR_DATA = 1000


class LinkedList:
    staticIdx = 0
    last = -1

    def __init__(self, val=None):
        self.val = val
        self.next = None
        self.prev = None
        if val is not None:
            # self.idx = LinkedList.staticIdx
            self.name = f"node_{LinkedList.staticIdx}"
            LinkedList.staticIdx += 1
        else:
            self.idx = -1
            self.name = "head"
            LinkedList.last = self

    def insert(self, val):
        newNode = LinkedList(val)
        LinkedList.last.next = newNode
        newNode.prev = LinkedList.last
        LinkedList.last = newNode

    def find_by_idx(self, index):
        if self.name == f"node_{index}":
            return self
        if self.next is None:
            return None
        return self.next.find_by_idx(index)

    def find_value(self, val):
        if self.val == val:
            return self
        if self.next is None:
            return None
        return self.next.find_value(val)

    def swap(self, source_idx, val):
        source_node = self.find_by_idx(source_idx)
        val_node = self.find_value(val)

        if (val_node is not None) and (source_node is not None):
            if val_node == source_node:
                return
            temp_next = source_node.next
            if val_node.next == source_node:
                source_node.next = val_node
            else:
                source_node.next = val_node.next
                source_node.prev.next = val_node
            if temp_next == val_node:
                val_node.next = source_node
            else:
                val_node.next = temp_next
                val_node.prev.next = source_node

    def listData(self):
        dataT = ""
        dataT += f"  {self.name}:\n"
        if self.val is not None:
            dataT += f"            .int {self.val}\n"
        if self.next is not None:
            dataT += f"            .quad {self.next.name}\n"
        else:
            dataT += f"            .quad 0\n"

        if self.next is not None:
            dataT += self.next.listData()
        return dataT

    def listCmps(self):
        cmpsT = ""
        disp = 0
        cmpsT += f"  movq ${self.name}, %rax\n"
        if self.val is not None:
            cmpsT += f"  cmpl ${self.val}, (%rax)\n"
            cmpsT += "  jne bad_exit\n"
            disp = 4
        if self.next is not None:
            cmpsT += f"  cmpq ${self.next.name}, {disp}(%rax)\n"
        else:
            cmpsT += f"  cmpq $0, {disp}(%rax)\n"
        cmpsT += "  jne bad_exit\n"
        cmpsT += "\n"

        if self.next is not None:
            cmpsT += self.next.listCmps()
        return cmpsT


intro = ".global _start\n\n  .section .text\n\n"
exits = "  movq $60, %rax\n  movq $0, %rdi\n  syscall\n\n"
exits += "bad_exit:\n  movq $60, %rax\n  movq $1, %rdi\n  syscall\n\n"

negTest = False
for m in range(REP_NUM):
    for i in range(0, NUM_TEST):
        f_test = open(f'./ex4/ex4test{NUM_TEST*m+i+1}', 'w')

        data = ".section .data\n"
        cmps = ""

        LinkedList.staticIdx = 0
        size = random.randint(1, MAX_ARR_SIZE)
        lList = LinkedList()
        myList = []

        for j in range(size):
            x = random.randint(1, MAX_ARR_DATA)
            myList.append(x)
            lList.insert(x)

        data += lList.listData()

        source = random.randint(0, len(myList)-1)
        value = random.randint(MAX_ARR_DATA+1, 2*MAX_ARR_DATA)
        idx = -1

        if i >= 3:
            value = random.choice(myList)
            idx = myList.index(value)

        data += f"  Source: .quad node_{source}\n"
        data += f"  Value: .int {value}\n"

        lList.swap(source, value)
        cmps += lList.listCmps()
        cmps += "\n"

        f_test.write(intro + cmps + exits + data + "\n\n")

        f_test.close()




