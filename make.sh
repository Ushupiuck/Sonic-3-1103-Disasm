#!/bin/bash
if test -f s3built.bin; then
	mv -f s3built.bin s3built.prev.bin
fi
./tool/linux/asl -xx -q -A -L -U -E -i . main.asm
./tool/linux/p2bin -p=FF -z=0,uncompressed,Size_of_driver_guess,after main.p s3built.bin
rm -f main.p