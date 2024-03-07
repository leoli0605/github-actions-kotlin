@echo off

REM Build Docker image
docker build -t android-kotlin .

REM Run Docker container
docker run -it --rm -v %cd%:/app -w /app android-kotlin /bin/bash
