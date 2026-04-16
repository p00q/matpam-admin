@echo off
echo Killing existing service on port 5052 (if running)...
FOR /F "tokens=5" %%a IN ('netstat -aon ^| find "LISTENING" ^| find ":5052"') DO taskkill /f /pid %%a 2>nul
echo Starting Matpam Admin on Port 5052...
echo.
call "%~dp0apache-maven-3.9.6\bin\mvn.cmd" clean jetty:run
pause
