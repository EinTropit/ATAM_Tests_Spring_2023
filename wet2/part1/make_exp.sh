MAX_TEST=5

echo "1"

gcc test_KM.c aux_tests.c aux_code.o funcs.c -o make_KM.out
if [ -f "make_KM.out" ]; then
	for ((i=1; i<=$MAX_TEST; i++)); do
		timeout 20s ./make_KM.out < "KM_tests/inputs/KM_input_${i}" > "KM_tests/expected/KM_exp_${i}"
	done
	rm "make_KM.out"
fi

echo "2"

gcc test_BS.c aux_tests.c aux_code.o funcs.c -o make_BS.out
if [ -f "make_BS.out" ]; then
	for ((i=1; i<=$MAX_TEST; i++)); do
		timeout 20s ./make_BS.out < "BS_tests/inputs/BS_input_${i}" > "BS_tests/expected/BS_exp_${i}"
	done
	rm "make_BS.out"
fi

echo "3"

gcc test_SR.c aux_tests.c aux_code.o funcs.c -o make_SR.out
if [ -f "make_SR.out" ]; then
	for ((i=1; i<=$MAX_TEST; i++)); do
		timeout 20s ./make_SR.out < "SR_tests/inputs/SR_input_${i}" > "SR_tests/expected/SR_exp_${i}"
	done
	rm "make_SR.out"
fi

echo "4"

gcc test_cipher.c aux_tests.c aux_code.o funcs.c -o make_cipher.out
if [ -f "make_cipher.out" ]; then
	for ((i=1; i<=$MAX_TEST; i++)); do
		timeout 20s ./make_cipher.out < "cipher_tests/inputs/cipher_input_${i}" > "cipher_tests/expected/cipher_exp_${i}"
	done
	rm "make_cipher.out"
fi