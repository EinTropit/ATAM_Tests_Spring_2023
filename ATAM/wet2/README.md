# tests for ATAM wet 2

* We suggest skipping trying the tests using wsl as you may break somthing in your own computer
* Clone / Download the files from the repository

## part 1
### How to run the tests
* Put your students_code.S with all the other files
* Running instructions: 
  - Open a shell terminal in .../ATAM/wet2/part1
  - to run all tests: ./runner.sh
* Generating new tests:
  - update the input files to your likings
  - Run: ./make_exp.sh
  - You have new expected files, now refer to running instructions

### notes
* If you see that the there is a diff in the files but they are the same, try using dos2unix or try running make_exp.sh


## part 2
### how to run
* Run each test as you are instructed in the HW (using the attached compile.sh and Makefile, and each test's files here)
* but you have to use the start.sh and filesystem.img you already have.

### notes
- These are not our tests, these are from previous years that were rearranged and provided here for easier use 
- We take no credit for them nor recieve or answer any complaints.



## Troubleshooting
* If the premission is denied execute: chmod +x "filename"
* If for some reason you have a reaccuring dos2unix problem, notify us
* google.com