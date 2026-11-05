@echo off
cd /d "%~dp0"
".tools\rojo\rojo.exe" build default.project.json --output build/RaceAndRaid-ChassisLab.rbxlx
if errorlevel 1 (pause & exit /b 1)
start "" "%~dp0build\RaceAndRaid-ChassisLab.rbxlx"