#!/bin/sh
# from http://qiita.com/nyanchu/items/15d514d9b9f87e5c0a29
which electron-packager > /dev/null 2>&1 || npm i electron-packager -g
electron-packager ./src nginx-gui --platform=darwin,linux --arch=x64 --version=0.35.4
# platform ･･･ all, linux, win32, darwin のいずれかを選択。複数入れる場合はカンマ区切りで。
# arch ･･･ all, ia32, x64 のいずれかを選択。
# version ･･･ Electronのバージョンを指定します
