#!/bin/bash

MAX_TEST=100

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

EXIT_STATUS=0
FINAL_TEST_STATUS=(1 1 1 1 1 1)

if [[ $1 =~ ^[1-5]+$ ]]; then 
	SINGLE_EX_MODE=1
	EX_BEGIN=$1
	EX_END=$1
else
	SINGLE_EX_MODE=0
	EX_BEGIN=1
	EX_END=5
fi

if [ -z "$2" ]; then
	TEMP=0
else
	TEMP=$2
fi

if (( "$TEMP" >= 1 && "$TEMP" <= $MAX_TEST )); then
	TEST_BEGIN=$2
	TEST_END=$2
else
	TEST_BEGIN=1
	TEST_END=$MAX_TEST
fi

for ((i=$EX_BEGIN; i<=$EX_END; i++)); do
	STATUS=0
	for ((j=$TEST_BEGIN; j<=$TEST_END; j++)); do 
		as "./asm_files/ex${i}.asm" "./ex${i}/ex${i}test${j}" -o merged.o

		if [ -f "merged.o" ]; then
			ld merged.o -o merged.out
			if [ -f "merged.out" ]; then
				timeout 60s ./merged.out	
				if [ $? -eq 0 ]; then
					echo -e "ex${i}test${j}: ${GREEN}PASS${NC}"
				else
					echo -e "ex${i}test${j}: ${RED}FAIL${NC}"
					STATUS=1
				fi
			else
				echo -e "ex${i}test${j} (ld stage): ${RED}FAIL${NC}"
				STATUS=1
			fi
		else
			echo -e "ex${i}test${j} (as stage): ${RED}FAIL${NC}"		
			STATUS=1
		fi
		rm merged.*
	done
	
	if [ $STATUS == 0 ]; then
		FINAL_TEST_STATUS[i]=0
	fi
done

if [ $SINGLE_EX_MODE == 0 ]; then
	for ((i=1; i<6; i++)); do
		if [ ${FINAL_TEST_STATUS[$i]} == 0 ]; then
			echo -e "ex${i} all tests status: ${GREEN}PASSED${NC}"
		else
			echo -e "ex${i} all tests status: (at least one test) ${RED}FAILED${NC}"
			EXIT_STATUS=1
		fi
	done
fi

echo -e "Terminating runner"
exit ${EXIT_STATUS}