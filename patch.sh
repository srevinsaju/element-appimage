#! /bin/sh

set -eux
sed -i 's,import AutoLaunch from "auto-launch";,import AutoLaunch from "auto-launch";\nimport * as appimage from "./appimage.js";,g' src/electron-main.ts
sed -i "s,global.launcher.enable();,appimage.enableAutoStart();,g" src/electron-main.ts
sed -i "s,global.launcher.disable(),appimage.disableAutoStart(),g" src/electron-main.ts
sed -i "s,await oldLauncher.isEnabled(),appimage.isAutoStartEnabled(),g" src/electron-main.ts

# update Node to be conform to prerequisites
sed -i 's,NODE_VERSION 20.15.1,NODE_VERSION 20.17.0,g' dockerbuild/Dockerfile

