@echo off
set /A N_Test=1
SET tpath=%~dp0

echo Hi! Please run this script after a malware scan
pause
goto Test%N_Test%

:options
	set /A N_Test=%N_Test%+1
	echo Has been worked the Test0%N_Test%?
	CHOICE /N /C:YN /M "y (yes) / n (not)"
	if %errorlevel% == 1 goto yes
	if %errorlevel% == 2 (
		goto Test%N_Test%
	)

:Test1
	cls
	echo Test 01: Trying to start ctfmon.exe...
	start cmd /C C:\Windows\system32\ctfmon.exe
	echo Copying ctfmon to startup...
	reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32 || set OS=64
	"%tpath%\nircmd%OS%\nircmd.exe" shortcut "C:\Windows\system32\ctfmon.exe" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" "ctfmon"
	taskkill /im explorer.exe /f
	start explorer.exe
	goto options

:Test2
	cls
	echo Test 02: Restarting TabletInputService...
	net stop TabletInputService
	if ERRORLEVEL 1 echo Error stoping TabletInputService.
	net start TabletInputService
	if ERRORLEVEL 1 echo Error starting TabletInputService.
	goto options

:Test3
	cls
	echo Test 03: Starting DISM.exe, it will take 30~60 minutes, please wait...
	DISM.exe /Online /Cleanup-image /Restorehealth
	echo Executing sfc scanning...
	sfc /scannow
	goto options

:Test4
	cls
	echo Sorry, i cannot fix Cortana search bar, please contact to Microsoft.
	TIMEOUT /T 5
	exit

:yes
	cls
	echo I hope i'd help you, bye.
	TIMEOUT /T 5


