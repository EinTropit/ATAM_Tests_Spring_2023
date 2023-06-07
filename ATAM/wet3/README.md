# Tests for ATAM wet 3

## How to run the tests
* Clone / Download the files from the repository
* Put the files 'hw3_part1.c' and 'hw3_part2.ld' in the 'wet3' folder
* Running instructions: 
  - Open a shell terminal in .../ATAM/wet3
  - to run all tests: ./runner.sh
  - to run one part only (insert number only): ./part#_runner.sh

### notes
* part 2 tests may fail because of parsing and differnces between machines, if you don't pass them try checking manually with the files named ./part2_exp_files/part2_###.exp
* part 2 does not work with WSL
* Since no sample tests were provided by the course stuff, if you are 100% percent sure we check somethimg in the wrong way you may notify us
* sources for the tests are available if you want them for some reason

### Troubleshooting
* If the premission is denied execute: chmod +x "filename"
* If you get the following message:
  - /bin/bash^M: bad interpreter: No such file or directory
  - Execute: sed -i -e 's/\r$//' "filename"
* google.com
