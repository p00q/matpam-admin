@echo off
echo Starting Matpam Admin on Port 5051...
echo.
call mvn clean jetty:run
pause
