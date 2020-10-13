@echo off
color 12
title   hardware     
mode con cols=82
sc config winmgmt start= auto >nul 2<&1
net start winmgmt 2>1nul
setlocal ENABLEDELAYEDEXPANSION
echo broad:
for /f "tokens=1,* delims==" %%a in ('wmic BASEBOARD get Manufacturer^,Product^,Version^,SerialNumber /value') do (
  set /a tee+=1
  if "!tee!" == "3" echo     band   = %%b
  if "!tee!" == "4" echo     type   = %%b
  if "!tee!" == "5" echo     number   = %%b
  if "!tee!" == "6" echo     version   = %%b
)
set tee=0
echo BIOS:
for /f "tokens=1,* delims==" %%a in ('wmic bios get 
CurrentLanguage^,Manufacturer^,SMBIOSBIOSVersion^,SMBIOSMajorVersion^,SMBIOSMinorVersion^,ReleaseDate /value') do (
  set /a tee+=1
  if "!tee!" == "3" echo     language = %%b
  if "!tee!" == "4" echo     band   = %%b
  if "!tee!" == "5" echo     release_date = %%b
  if "!tee!" == "6" echo     version   = %%b
  if "!tee!" == "7" echo     SMBIOSMajorVersion = %%b
  if "!tee!" == "8" echo     SMBIOSMinorVersion = %%b 
)
set tee=0
echo.
echo CPU:
REM for /f "tokens=1,* delims==" %%a in ('wmic cpu get name^,ExtClock^,CpuStatus^,Description /value') do (
REM   set /a tee+=1
REM   if "!tee!" == "1" echo     CPU_num   = %%b
REM   if "!tee!" == "4" echo     version   = %%b
REM   if "!tee!" == "5" echo     FSB  = %%b
REM   if "!tee!" == "6" echo     multiple frequency   = %%b
REM )
wmic cpu get stepping, name, ThreadCount, NumberOfCores
set tee=0
echo.
echo monitor:
for /f "tokens=1,* delims==" %%a in ('wmic DESKTOPMONITOR get name^,ScreenWidth^,ScreenHeight^,PNPDeviceID /value') do (
  set /a tee+=1
  if "!tee!" == "3" echo     type = %%b
  if "!tee!" == "4" echo     info = %%b
  if "!tee!" == "5" echo     height   = %%b
  if "!tee!" == "6" echo     width   = %%b
)
set tee=0
echo.
echo disk:
for /f "tokens=1,* delims==" %%a in ('wmic DISKDRIVE get model^,interfacetype^,size^,totalsectors^,partitions /value') do (
  set /a tee+=1
  if "!tee!" == "3" echo     interface_type = %%b
  if "!tee!" == "4" echo     type = %%b
  if "!tee!" == "5" echo     part_num   = %%b
  if "!tee!" == "6" echo     size = %%b
  if "!tee!" == "7" echo     vectors_num   = %%b
)
echo disk_info:
wmic LOGICALDISK where mediatype='12' get description,deviceid,filesystem,size,freespace
set tee=0
echo.
echo nic:
for /f "tokens=1,* delims==" %%a in ('wmic NICCONFIG where "index='1'" get ipaddress^,macaddress^,description /value') do (
  set /a tee+=1
  if "!tee!" == "3" echo     type = %%b
  if "!tee!" == "4" echo     IP   = %%b
  if "!tee!" == "5" echo     MAC   = %%b
)
set tee=0
echo.
echo sound_card:
for /f "tokens=1,* delims==" %%a in ('wmic SOUNDDEV get name^,deviceid /value') do (
  set /a tee+=1
  if "!tee!" == "3" echo     info = %%b
  if "!tee!" == "4" echo     type = %%b
)
set tee=0
echo.
echo memory: 
for /f "tokens=1,* delims==" %%a in ('systeminfo^|find "Memory"') do (
  echo       %%a 4534 %%b 
)
echo.
echo Graphics_card:
del /f "%TEMP%\temp.txt" 2>nul
dxdiag /t %TEMP%\temp.txt
if EXIST "%TEMP%\temp.txt" (
  for /f "tokens=1,2,* delims=:" %%a in ('findstr /c:" Card name:" /c:"Display Memory:" /c:"Current Mode:" "%TEMP%\temp.txt"') do (
      set /a tee+=1
      if !tee! == 1 echo   type: %%b
      if !tee! == 2 echo   memory_size: %%b
      if !tee! == 3 echo   settings: %%b
)   ) else (
  ping /n 2 127.1>nul
  goto Graphics_card
)
pause
