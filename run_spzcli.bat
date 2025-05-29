@echo off
REM Set default input and output paths
set INPUT=/data/example.ply
set OUTPUT=/data/output.spz

REM build the docker container
docker build -t spzcli .

REM Run the Docker container, example.ply should be in the /test folder in root repo dir
docker run --rm -v "%cd%\test:/data" spzcli %INPUT% %OUTPUT%

REM Pause so the window doesn't close immediately
echo.
pause
