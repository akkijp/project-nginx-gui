#!/bin/sh
which asar > /dev/null 2>&1 || npm install -g asar
asar pack ./src ./nginx-gui.asar
