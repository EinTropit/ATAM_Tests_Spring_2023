gcc test_KM.c aux_tests.c aux_code.o students_code.S -o test_KM.out
if [ -f "test_KM.out" ]; then
	timeout 20s ./test_KM.out < test_KM_1 > KM_out
	if [ $? -eq 0 ]; then
		diff KM_out test_KM_1_res
		if [ $? -eq 0 ]; then
			echo -e "1: PASS!"
		fi
	fi
fi

gcc test_BS.c aux_tests.c aux_code.o students_code.S -o test_BS.out
if [ -f "test_KM.out" ]; then
	timeout 20s ./test_BS.out < test_BS_1 > BS_out
	if [ $? -eq 0 ]; then
		diff BS_out test_BS_1_res
		if [ $? -eq 0 ]; then
			echo -e "2: PASS!"
		fi
	fi
fi

gcc test_SR.c aux_tests.c aux_code.o students_code.S -o test_SR.out
if [ -f "test_KM.out" ]; then
	timeout 20s ./test_SR.out < test_SR_1 > SR_out
	if [ $? -eq 0 ]; then
		diff SR_out test_SR_1_res
		if [ $? -eq 0 ]; then
			echo -e "3: PASS!"
		fi
	fi
fi
 
gcc test_cipher.c aux_tests.c aux_code.o students_code.S -o test_cipher.out
if [ -f "test_KM.out" ]; then
	timeout 20s ./test_cipher.out < test_cipher_1 > cipher_out
	if [ $? -eq 0 ]; then
		diff cipher_out test_cipher_1_res
		if [ $? -eq 0 ]; then
			echo -e "4: PASS!"
		fi
	fi
	timeout 20s ./test_cipher.out < test_cipher_2 > cipher_out
	if [ $? -eq 0 ]; then
		diff cipher_out test_cipher_2_res
		if [ $? -eq 0 ]; then
			echo -e "5: PASS!"
		fi
	fi
fi