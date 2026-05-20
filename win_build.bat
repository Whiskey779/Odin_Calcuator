@echo off
setlocal enabledelayedexpansion

set "PROJECT_NAME=Odin_Calcuator"
set "SOURCE_DIR=."
set "BUILD_DIR=bin"

:: Default mode = debug
set "MODE=%2"
if "%MODE%"=="" set "MODE=debug"

if "%1"=="build" (
    if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

    if /I "%MODE%"=="release" (
        echo Building RELEASE...
        odin build "%SOURCE_DIR%" ^
            -out:"%BUILD_DIR%/%PROJECT_NAME%.exe" ^
            -o:speed
    ) else (
        echo Building DEBUG...
        odin build "%SOURCE_DIR%" ^
            -out:"%BUILD_DIR%/Debug-%PROJECT_NAME%.exe" ^
            -debug
    )
    goto :eof
)

if "%1"=="run" (
    if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

    if /I "%MODE%"=="release" (
        echo Running RELEASE...
        odin run "%SOURCE_DIR%" -o:speed
    ) else (
        echo Running DEBUG...
        odin run "%SOURCE_DIR%" -debug
    )
    goto :eof
)

if "%1"=="clean" (
    echo Cleaning build directory...
    if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
    goto :eof
)

echo Usage:
echo   build.bat build [debug^|release]
echo   build.bat run [debug^|release]
echo   build.bat clean

exit /b 1