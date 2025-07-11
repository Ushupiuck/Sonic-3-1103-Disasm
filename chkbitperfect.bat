@echo OFF

REM // build the ROM
call build

REM // compare built ROM with dumped ROM
echo ----
if exist s3built.bin ( fc /b s3built.bin s3original.bin )

REM // if someone ran this from Windows Explorer, prevent the window from disappearing immediately
pause