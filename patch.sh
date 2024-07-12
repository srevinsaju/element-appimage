#! /bin/sh


set -eux
sed -i 's,import AutoLaunch from "auto-launch";,import AutoLaunch from "auto-launch";import * as appimage from "./appimage";,g' src/electron-main.ts
sed -i "s,global.launcher.enable();,appimage.enableAutoStart();,g" src/electron-main.ts
sed -i "s,global.launcher.disable(),appimage.disableAutoStart(),g" src/electron-main.ts
sed -i "s,await oldLauncher.isEnabled(),appimage.isAutoStartEnabled(),g" src/electron-main.ts

# fix docker build on element-desktop
if ! grep -q WORKDIR dockerbuild/Dockerfile
then
  echo 'WORKDIR /project' >> dockerbuild/Dockerfile
fi

# use Node 20 LTS on docker image
sed -i 's,NODE_VERSION 18.19.*,NODE_VERSION 20.15.1,g' dockerbuild/Dockerfile
