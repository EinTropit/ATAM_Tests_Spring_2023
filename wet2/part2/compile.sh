#!/bin/bash

echo
echo '[*] Compiling'
echo
make clean && make

echo
echo '[*] Copying "ili.ko", "bad_inst" into VM'
echo
sudo mkdir _fs
sudo mount filesystem.img _fs
sudo cp -f ili.ko bad_inst _fs/root/
sudo umount _fs
sudo rm -rf _fs

echo
echo '[*] Done'
echo
