# nginx-gui

![Hello nginx-gui](https://raw.github.com/wiki/k4zzk/nginx-gui/images/20151223/img_01.png)
![Hello nginx-gui](https://raw.github.com/wiki/k4zzk/nginx-gui/images/20151223/img_02.png)


install
-------

Get Start
※事前に、brewで、nginx, php56-fpm, mysqlのインストールが必要です。  
[http://brew.sh/index_ja.html](http://brew.sh/index_ja.html) より、インストールをお願いします。

```sh
brew install nginx php56-fpm mysql
```

node install

```sh
brew install node
```

electron install

```sh
npm -g install electron-prebuilt
```

nginx-gui start

```sh
git clone https://github.com/k4zzk/nginx-gui.git && cd nginx-gui
npm install
gulp install
gulp run
```

LICENCE
-------
MIT LICENCE
