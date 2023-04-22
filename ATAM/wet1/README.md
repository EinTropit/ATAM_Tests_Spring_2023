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

### Troubleshooting
* If the premission is denied execute: chmod +x "filename"
* If you get the following message:
  - /bin/bash^M: bad interpreter: No such file or directory
  - Execute: sed -i -e 's/\r$//' "filename"
* google.com
