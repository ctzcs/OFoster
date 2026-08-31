@echo off
cd /d "%~dp0"
set SAMPLE=%~1
if "%SAMPLE%"=="" set SAMPLE=basic
if not exist "samples\%SAMPLE%\main.odin" exit /b 1
if not exist build mkdir build
odin build "samples\%SAMPLE%" -out:"build\%SAMPLE%.exe"
if errorlevel 1 exit /b %errorlevel%
"build\%SAMPLE%.exe"
