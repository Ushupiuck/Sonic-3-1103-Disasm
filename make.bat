@echo off
if exist s3built.bin move /y s3built.bin s3built.prev.bin >NUL
tool\windows\asw -xx -q -A -L -U -E -i . main.asm
tool\windows\p2bin -p=FF -z=0,uncompressed,Size_of_driver_guess,after main.p s3built.bin
del main.p