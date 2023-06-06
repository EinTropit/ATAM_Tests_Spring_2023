#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

EXIT_STATUS=0

echo "running part1 test"
echo
./part1_runner.sh
echo ------------------
if [ $? -eq 0 ]; then
    echo -e "part1 test ${i}: ${GREEN}PASS${NC}"
else
    EXIT_STATUS=1
    echo -e "part1 test ${i}: ${RED}FAIL${NC}"
fi
echo ------------------
echo
echo "running part2 test"
echo 
./part2_runner.sh
echo ------------------
if [ $? -eq 0 ]; then
    echo -e "part2 test ${i}: ${GREEN}PASS${NC}"
else
    EXIT_STATUS=1
    echo -e "part2 test ${i}: ${RED}FAIL${NC}"
fi
echo ------------------
exit ${EXIT_STATUS}
