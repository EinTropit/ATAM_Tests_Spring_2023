#!/bin/bash

MAX_TEST=10

EX_TO_TEST=3

# single test mode
SINGLE_TEST_MODE=0
TEST_NUMBER=1


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

STATUS=0

if [ $SINGLE_TEST_MODE == 0 ]; then
	if [ $EX_TO_TEST == 0 ]; then
		for ((i=1; i<6; i++)); do
			LOOP_STATUS=0
			for ((j=1; j<$MAX_TEST; j++)); do 
				as "ex${i}.asm" "../ATAM_tests/ex${i}/ex${i}test${j}" -o merged.o

				if [ -f "merged.o" ]; then
					ld merged.o -o merged.out
					if [ -f "merged.out" ]; then
						timeout 60s ./merged.out	
						if [ $? -eq 0 ]; then
							echo -e "ex${i}test${j}: ${GREEN}PASS${NC}"
							STATUS=0
						else
							echo -e "ex${i}test${j}: ${RED}FAIL${NC}"
							STATUS=1
							LOOP_STATUS=1
						fi
					else
						echo -e "ex${i}test${j} (ld stage): ${RED}FAIL${NC}"
						STATUS=1
						LOOP_STATUS=1
					fi
				else
					echo -e "ex${i}test${j} (as stage): ${RED}FAIL${NC}"		
					STATUS=1
					LOOP_STATUS=1
				fi
				rm merged.*
			done
			if [ $LOOP_STATUS == 1 ]; then
				echo -e "Passed all ex${i} tests? ${RED}NO ):${NC}"
			else
				echo -e "Passed all ex${i} tests? ${GREEN}YES (:${NC}"
			fi
		done
	else
		for ((j=1; j<$MAX_TEST; j++)); do 
			as "ex${EX_TO_TEST}.asm" "../ATAM_tests/ex${EX_TO_TEST}/ex${EX_TO_TEST}test${j}" -o merged.o

			if [ -f "merged.o" ]; then
				ld merged.o -o merged.out
				if [ -f "merged.out" ]; then
					timeout 60s ./merged.out	
					if [ $? -eq 0 ]; then
						echo -e "ex${EX_TO_TEST}test${j}: ${GREEN}PASS${NC}"
						STATUS=0
					else
						echo -e "ex${EX_TO_TEST}test${j}: ${RED}FAIL${NC}"
						STATUS=1
					fi
				else
					echo -e "ex${EX_TO_TEST}test${j} (ld stage): ${RED}FAIL${NC}"
					STATUS=1	
				fi
			else
				echo -e "ex${EX_TO_TEST}test${j} (as stage): ${RED}FAIL${NC}"		
				STATUS=1
			fi
			rm merged.*
		done
	fi
else
	if (($EX_TO_TEST >= 1 && $EX_TO_TEST <= 5 && $TEST_NUMBER >=1 && $TEST_NUMBER <= $MAX_TEST)); then
		as "ex${EX_TO_TEST}.asm" "../ATAM_tests/ex${EX_TO_TEST}/ex${EX_TO_TEST}test${TEST_NUMBER}" -o merged.o

		if [ -f "merged.o" ]; then
			ld merged.o -o merged.out
			if [ -f "merged.out" ]; then
				timeout 60s ./merged.out	
				if [ $? -eq 0 ]; then
					echo -e "ex${EX_TO_TEST}test${j}: ${GREEN}PASS${NC}"
					STATUS=0
				else
					echo -e "ex${EX_TO_TEST}test${j}: ${RED}FAIL${NC}"
					STATUS=1
				fi
			else
				echo -e "ex${EX_TO_TEST}test${j} (ld stage): ${RED}FAIL${NC}"
				STATUS=1	
			fi
		else
			echo -e "ex${EX_TO_TEST}test${j} (as stage): ${RED}FAIL${NC}"		
			STATUS=1
		fi
		rm merged.*
	else
		echo -e "${RED}ex number or test number problem${NC}"
		echo -e "${YELLOW}make sure you use the right mode!${NC}"
		STATUS=1
	fi
fi
echo -e "${YELLOW}Terminating runner${NC}"
exit ${STATUS}

