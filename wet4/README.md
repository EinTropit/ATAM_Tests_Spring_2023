# Tests for ATAM wet 4

## How to run the tests
* Clone / Download the files from the repository
* Put the all your code *excluding elf64.h* files in the 'wet4/your_files' folder
* Running instructions: 
  - Open a shell terminal in .../ATAM/wet4
  - to run all tests: ./runner.sh

### notes
* IMPORTANT - we do not check any case that was already tested in WET3 
* no individual test running provided
* should work with WSL
* Since no sample tests were provided by the course stuff, if you are 100% percent sure we check somethimg in the wrong way you may notify us
* sources for the tests are available if you want them for some reason
* we compile and add a dynamic library to /usr/lib/ - note that it will stay on your computer if you use WSL

### Troubleshooting
* if you fail a test and the files are identical execute: dos2unix "filepath"
* If the premission is denied execute: chmod +x "filename"
* If you get the following message:
  - /bin/bash^M: bad interpreter: No such file or directory
  - Execute: sed -i -e 's/\r$//' "filename"
* to remove the dynamic library run: rm /usr/lib/ATAM_test_lib.so
* google.com
* ![alt text](https://i.kym-cdn.com/entries/icons/original/000/012/073/7686178464_fdc8ea66c7.jpg)

