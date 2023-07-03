#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

EXIT_STATUS=0
echo -e "COMPILING STUFF"

# lib compilation
gcc -shared -fPIC -o ATAM_test_lib.so testlib.c
sudo mv ATAM_test_lib.so /usr/lib/
gcc -no-pie -o test.exec test.c asmtest.S /usr/lib/ATAM_test_lib.so -Wl,-zlazy

# exec compilation
gcc -std=c99 ./your_files/*.c -o prf.exec

if [ -f "prf.exec" ]; then
    echo -e "RUNNING TESTS"

    # run tests
    ./prf.exec hash        ./test.exec > ./outputs/test1.out
    ./prf.exec fact        ./test.exec > ./outputs/test2.out
    ./prf.exec comp        ./test.exec > ./outputs/test3.out
    ./prf.exec uselessFunc ./test.exec > ./outputs/test4.out
    ./prf.exec recA        ./test.exec > ./outputs/test5.out
    ./prf.exec recB        ./test.exec > ./outputs/test6.out

    # diff tests
    for ((i=1; i<=6; i++)); do
        diff "./expected/test${i}.exp" "./outputs/test${i}.out" &>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "test ${i}: ${GREEN}PASS${NC}"
        else
            EXIT_STATUS=1
            echo -e "test ${i}: ${RED}FAIL${NC}"
        fi
    done
else
    echo -e "test ${i}: ${RED}Compilation problem${NC}"
    EXIT_STATUS=1
fi

exit ${EXIT_STATUS}
