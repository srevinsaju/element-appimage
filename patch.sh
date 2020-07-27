#! /bin/sh
sed -i "s,const AutoLaunch = require('auto-launch');,const AutoLaunch = require('auto-launch');const appimage = require('./appimage');,g" src/electron-main.js
sed -i "s,launcher.enable();,appimage.enableAutoStart();,g" src/electron-main.js
sed -i "s,launcher.disable(),appimage.disableAutoStart(),g" src/electron-main.js
sed -i "s,await launcher.isEnabled(),appimage.isAutoStartEnabled(),g" src/electron-main.js
