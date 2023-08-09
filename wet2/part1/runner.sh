MAX_TEST=5

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

gcc test_KM.c aux_tests.c aux_code.o students_code.S -o test_KM.out
if [ -f "test_KM.out" ]; then
	for ((i=1; i<=$MAX_TEST; i++)); do
		timeout 20s ./test_KM.out < "KM_tests/inputs/KM_input_${i}" > "KM_tests/outputs/KM_out_${i}"
		if [ $? -eq 0 ]; then
			diff "KM_tests/outputs/KM_out_${i}" "KM_tests/expected/KM_exp_${i}" &>/dev/null
			if [ $? -eq 0 ]; then
				echo -e "KM${i}: ${GREEN}PASS!${NC}"
			else
				echo -e "KM${i}: ${RED}FAIL${NC}"
			fi
		fi
	done
	rm "test_KM.out"
fi

echo "  "

gcc test_BS.c aux_tests.c aux_code.o students_code.S -o test_BS.out
if [ -f "test_BS.out" ]; then
	for ((i=1; i<=$MAX_TEST; i++)); do
		timeout 20s ./test_BS.out < "BS_tests/inputs/BS_input_${i}" > "BS_tests/outputs/BS_out_${i}"
		if [ $? -eq 0 ]; then
			diff "BS_tests/outputs/BS_out_${i}" "BS_tests/expected/BS_exp_${i}" &>/dev/null
			if [ $? -eq 0 ]; then
				echo -e "BS${i}: ${GREEN}PASS!${NC}"
			else
				echo -e "BS${i}: ${RED}FAIL${NC}"
			fi
		fi
	done
	rm "test_BS.out"
fi

echo "  "

gcc test_SR.c aux_tests.c aux_code.o students_code.S -o test_SR.out
if [ -f "test_SR.out" ]; then
	for ((i=1; i<=$MAX_TEST; i++)); do
		timeout 20s ./test_SR.out < "SR_tests/inputs/SR_input_${i}" > "SR_tests/outputs/SR_out_${i}"
		if [ $? -eq 0 ]; then
			diff "SR_tests/outputs/SR_out_${i}" "SR_tests/expected/SR_exp_${i}" &>/dev/null
			if [ $? -eq 0 ]; then
				echo -e "SR${i}: ${GREEN}PASS!${NC}"
			else
				echo -e "SR${i}: ${RED}FAIL${NC}"
			fi
		fi
	done
	rm "test_SR.out"
fi

echo "  "

gcc test_cipher.c aux_tests.c aux_code.o students_code.S -o test_cipher.out
if [ -f "test_cipher.out" ]; then
	for ((i=1; i<=$MAX_TEST; i++)); do
		timeout 20s ./test_cipher.out < "cipher_tests/inputs/cipher_input_${i}" > "cipher_tests/outputs/cipher_out_${i}"
		if [ $? -eq 0 ]; then
			diff "cipher_tests/outputs/cipher_out_${i}" "cipher_tests/expected/cipher_exp_${i}" &>/dev/null
			if [ $? -eq 0 ]; then
				echo -e "cipher${i}: ${GREEN}PASS!${NC}"
			else
				echo -e "cipher${i}: ${RED}FAIL${NC}"
			fi
		fi
	done
	rm "test_cipher.out"
fi