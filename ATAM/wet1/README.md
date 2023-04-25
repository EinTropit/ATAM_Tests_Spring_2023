# generate tests for ATAM wet 1

## How to run the tests
* Clone / Download the files from the repository
* Put all 5 of your ex{i}.asm files in the folder with name 'asm_files'
* Running instructions: 
  - Open a shell terminal in .../ATAM/wet1
  - to run all tests: ./runner.sh
  - to run all tests on one ex (insert number only): ./runner.sh "ex_num"
  - to run a single test (insert number only): ./runner.sh "ex_num" "test_num"
* Generating new tests:
  - Run: python generate_tests{i}.py

### notes
* ex4 tests were changed to check node swap (with the pointers) istead of value swap only
* For more tests in a batch, you should:
  - in 'generate_tests{i}.py' increse 'REP_NUM'. DO NOT CHANGE 'NUM_TEST'
  - in 'runner.sh' change 'MAX_TEST' to 'REP_NUM' * 'NUM_TEST'
* For longer tests you should:
  - in 'generate_tests{i}.py' increase 'MAX_ARR_SIZE' to increase the max number of values used
  - in 'generate_tests{i}.py' increase 'MAX_ARR_DATA' to increase the max number each value can be

### Troubleshooting
* If the premission is denied execute: chmod +x "filename"
* If you get the following message:
  - /bin/bash^M: bad interpreter: No such file or directory
  - Execute: sed -i -e 's/\r$//' "filename"
* google.com
