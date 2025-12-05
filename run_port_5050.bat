@echo off
echo Starting Matpam Admin on Port 5050...
echo.
call mvn clean jetty:run
pause
