@echo off

setlocal
set KFDIR=d:\Games\kf
set STEAMDIR=c:\Steam\steamapps\common\KillingFloor
set outputdir=D:\KFOut\ScrnHTec

echo Removing previous release files...
del /S /Q %outputdir%\*


echo Compiling project...
call make.cmd
if %ERRORLEVEL% NEQ 0 goto end

echo Exporting .int file...
%KFDIR%\system\ucc dumpint ScrnHTec.u

echo.
echo Copying release files...
mkdir %outputdir%\Animations
mkdir %outputdir%\System
mkdir %outputdir%\uz2


copy /y %KFDIR%\system\ScrnHTec.* %outputdir%\System\
copy /y %STEAMDIR%\Animations\HTec_A.ukx %outputdir%\Animations\
copy /y readme.txt  %outputdir%
copy /y changes.txt  %outputdir%


echo Compressing to .uz2...
%KFDIR%\system\ucc compress %KFDIR%\system\ScrnHTec.u
%KFDIR%\system\ucc compress %STEAMDIR%\Animations\HTec_A.ukx

move /y %KFDIR%\system\ScrnHTec.u.uz2 %outputdir%\uz2
move /y %STEAMDIR%\Animations\HTec_A.ukx.uz2 %outputdir%\uz2

echo Release is ready!

endlocal

pause

:end
