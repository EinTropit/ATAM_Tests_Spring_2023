#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

EXIT_STATUS=0

gcc hw3_part1.c -o part1.exec

if [ -f "part1.exec" ]; then
    echo "running inputs"
    timeout 20s ./part1.exec _start part1_1.exec > ./part1_out_files/test_1.out
    timeout 20s ./part1.exec msg2 part1_1.exec > ./part1_out_files/test_2.out
    timeout 20s ./part1.exec msg part1_1.exec > ./part1_out_files/test_3.out
    timeout 20s ./part1.exec exit part1_1.exec > ./part1_out_files/test_4.out
    timeout 20s ./part1.exec Tony_and_Noam part1_1.exec > ./part1_out_files/test_5.out
    timeout 20s ./part1.exec The_One_Piece part1_1.exec > ./part1_out_files/test_6.out
    timeout 20s ./part1.exec msg1 part1_1.o > ./part1_out_files/test_7.out
    timeout 20s ./part1.exec msg3 part1_2.o > ./part1_out_files/test_8.out
    timeout 20s ./part1.exec purple part1_3.exec > ./part1_out_files/test_9.out
    timeout 20s ./part1.exec _hw3_unicorn part1_3.exec > ./part1_out_files/test_10.out
    echo "running diff"
    for ((i=1; i<=10; i++)); do
        diff "./part1_exp_files/test_${i}.exp" "./part1_out_files/test_${i}.out" &>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "test ${i}: ${GREEN}PASS${NC}"
        else
            EXIT_STATUS=1
            echo -e "test ${i}: ${RED}FAIL${NC}"
        fi
    done
else
    EXIT_STATUS=1
fi

exit ${EXIT_STATUS}