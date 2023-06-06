#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

EXIT_STATUS=0

ld -T ./hw3_part2.ld -o 'part2.exec' 'link_test.o'

if [ -f "part2.exec" ]; then
    readelf -s part2.exec > ./part2_out_files/part2_s.out
    
    diff "./part2_exp_files/part2_s.exp" "./part2_out_files/part2_s.out" &>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "symbol test ${i}: ${GREEN}PASS${NC}"
    else
        EXIT_STATUS=1
        echo -e "symbol test ${i}: ${RED}FAIL${NC}"
    fi
    
    readelf -WS part2.exec > ./part2_out_files/part2_WS.out

    diff "./part2_exp_files/part2_WS.exp" "./part2_out_files/part2_WS.out" &>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "section test ${i}: ${GREEN}PASS${NC}"
    else
        EXIT_STATUS=1
        echo -e "section test ${i}: ${RED}FAIL${NC}"
    fi    

    ./part2.exec
    if [ $? -eq 0 ]; then
        echo -e "entry test ${i}: ${GREEN}PASS${NC}"
    else
        EXIT_STATUS=1
        echo -e "entry test ${i}: ${RED}FAIL${NC}"
    fi

else
    EXIT_STATUS=1
fi

exit ${EXIT_STATUS}