#!/usr/bin/env python3
import numpy as np
import functools
import random
import os


NUM_TEST = 20
REP_NUM = 5

MAX_TREE_SIZE = 50
MAX_TREE_DATA = 1000


class BSTNode:
    staticIdx = 0

    def __init__(self, val=None, new=False):
        self.left = None
        self.right = None
        self.val = val
        if new:
            self.name = "new_node"
        else:
            self.name = f"node_{BSTNode.staticIdx}"
            BSTNode.staticIdx += 1

    def insert(self, val, new = False):
        if not self.val:
            self.val = val
            return

        if self.val == val:
            return

        if val < self.val:
            if self.left:
                self.left.insert(val, new)
                return
            self.left = BSTNode(val, new)
            return

        if self.right:
            self.right.insert(val, new)
            return
        self.right = BSTNode(val, new)

    def treeData(self):
        dataT = ""
        if self.val is not None:
            dataT += f"  {self.name}:\n"
            dataT += f"            .quad {self.val}\n"
            if self.left is not None:
                dataT += f"            .quad {self.left.name}\n"
            else:
                dataT += f"            .quad 0\n"
            if self.right is not None:
                dataT += f"            .quad {self.right.name}\n"
            else:
                dataT += f"            .quad 0\n"

            if self.left is not None:
                dataT += self.left.treeData()
            if self.right is not None:
                dataT += self.right.treeData()
        return dataT


    def treeCmps(self):
        cmpsT = ""
        if self is not None:
            cmpsT += f"  movq ${self.name}, %rax\n"
            cmpsT += f"  cmpq ${self.val}, (%rax)\n"
            cmpsT += "  jne bad_exit\n"
            if self.left is not None:
                cmpsT += f"  cmpq ${self.left.name}, 8(%rax)\n"
            else:
                cmpsT += f"  cmpq $0, 8(%rax)\n"
            cmpsT += "  jne bad_exit\n"
            if self.right is not None:
                cmpsT += f"  cmpq ${self.right.name}, 16(%rax)\n"
            else:
                cmpsT += f"  cmpq $0, 16(%rax)\n"
            cmpsT += "  jne bad_exit\n"
            cmpsT += "\n"

            if self.left is not None:
                cmpsT += self.left.treeCmps()
            if self.right is not None:
                cmpsT += self.right.treeCmps()
        return cmpsT


intro = ".global _start\n\n  .section .text\n\n"
exits = "  movq $60, %rax\n  movq $0, %rdi\n  syscall\n\n"
exits += "bad_exit:\n  movq $60, %rax\n  movq $1, %rdi\n  syscall\n\n"

negTest = False
for m in range(REP_NUM):
    for i in range(0, NUM_TEST):
        f_test = open(f'./ex5/ex5test{NUM_TEST*m+i+1}', 'w')

        data = ".section .data\n"
        cmps = ""

        size = random.randint(1, MAX_TREE_SIZE)
        BSTNode.staticIdx = 0
        tree = BSTNode()
        myList = []

        for j in range(size):
            x = random.randint(1, MAX_TREE_DATA)
            tree.insert(x)
            myList.append(x)

        data += "  root: .quad node_0\n"
        data += tree.treeData()

        if i < 2:
            newVal = random.choice(myList)
        else:
            newVal = random.randint(1, MAX_TREE_DATA)

        data += f"  new_node: .quad {newVal}, 0, 0\n"
        tree.insert(newVal, True)
        cmps += tree.treeCmps()

        cmps += "\n"

        f_test.write(intro + cmps + exits + data + "\n\n")

        f_test.close()
