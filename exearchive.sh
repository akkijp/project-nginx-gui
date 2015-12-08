#!/bin/sh
which asar > /dev/null 2>&1 || npm install -g asar
asar pack ./src ./app.asar &&
cp -r ./electron-v0.35.4-darwin-x64/Electron.app ./Electron.app &&
mv ./app.asar ./Electron.app/Contents/Resources/

# http://qiita.com/Quramy/items/a4be32769366cfe55778
# これを後に適用
