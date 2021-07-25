#! /bin/sh
sed -i 's,import AutoLaunch from "auto-launch";import AutoLaunch from "auto-launch";import appimage from "./appimage";,g' src/electron-main.ts
sed -i "s,launcher.enable();,appimage.enableAutoStart();,g" src/electron-main.ts
sed -i "s,launcher.disable(),appimage.disableAutoStart(),g" src/electron-main.ts
sed -i "s,await launcher.isEnabled(),appimage.isAutoStartEnabled(),g" src/electron-main.ts
