@echo off
setlocal

if not exist build (
	mkdir build
)
pushd build

qmake ..\KeyBuddy.pro
if %errorlevel% neq 0 (
	echo qmake failed. Please ensure Qt is installed and qmake is in PATH.
	echo You can alternatively use CMake builder:
	echo   pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\build-cmake.ps1
	popd
	exit /b 1
)

where nmake >nul 2>nul
if %errorlevel%==0 (
	nmake
) else (
	where mingw32-make >nul 2>nul
	if %errorlevel%==0 (
		mingw32-make
	) else (
		echo No suitable make tool found. Please ensure nmake or mingw32-make is in PATH.
		echo Or use CMake builder:
		echo   pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\build-cmake.ps1
		popd
		exit /b 1
	)
)

popd
endlocal


