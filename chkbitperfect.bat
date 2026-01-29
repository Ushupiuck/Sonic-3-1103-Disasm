@echo off
call tool/md5 s3built.bin md5
if "%md5%" equ "05ae03e1049dcfe417d38b031dc696fb" (
	echo MD5 identical!
) else (
	echo MD5 does not match.
)
pause