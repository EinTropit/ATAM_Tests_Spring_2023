#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

gcc hw3_part1.c -o part1.exec

if [ -f "part1.exec" ]; then
    timeout 20s ./part1.exec _start part1_1.exec > output.out
    timeout 20s ./part1.exec msg2 part1_1.exec >> output.out
    timeout 20s ./part1.exec msg part1_1.exec >> output.out
    timeout 20s ./part1.exec exit part1_1.exec >> output.out
    timeout 20s ./part1.exec Tony_and_Noam part1_1.exec >> output.out
    timeout 20s ./part1.exec The_One_Piece part1_1.exec >> output.out
    timeout 20s ./part1.exec msg2 part1_1.o >> output.out
    timeout 20s ./part1.exec msg2 part1_2.o >> output.out
    timeout 20s ./part1.exec purple part1_3.exec >> output.out
    timeout 20s ./part1.exec _hw3_unicorn part1_3.exec >> output.out
    
    diff "expected.out" "output.out" &>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}PASS!${NC}"
    else
        echo -e "${RED}FAIL${NC}"
    fi
    rm "part1.exec"
fi