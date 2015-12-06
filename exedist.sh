#!/bin/sh
which electron-packager > /dev/null 2>&1 || npm i electron-packager -g
electron-packager ./src nginx-gui --platform=darwin,linux --arch=x64 --version=0.30.0
