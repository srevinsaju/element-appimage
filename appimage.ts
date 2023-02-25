
import os from 'os';
import fs from 'fs';
// import process from 'process';

console.log("Element AppImage Build")
let pathToAppImage: string;
if (process.env.APPIMAGE == null) {
    pathToAppImage = "element-desktop";
} else {
    pathToAppImage = process.env.APPIMAGE;
};

function getDesktopFile(path: string) {
    return `[Desktop Entry]
Name=Element
Comment=A feature-rich client for Matrix
Exec=${path} --hidden %u
Terminal=false
Type=Application
Icon=element
StartupWMClass=element
Categories=Network;InstantMessaging;Chat;IRCClient
MimeType=x-scheme-handler/element;`

};


export function isAutoStartEnabled() {
    if (fs.existsSync(`${os.homedir()}/.config/autostart/element.desktop`)) {
        return true;
    } else {
        return false;
    }    
};

export function enableAutoStart() {
    fs.writeFile(
        `${os.homedir()}/.config/autostart/element.desktop`,
        getDesktopFile(pathToAppImage), 
        function (err) {
            if (err) return console.log(err);
            console.log('Autostart desktop file');
        }
    );
};

export function disableAutoStart() {
    fs.unlink(`${os.homedir()}/.config/autostart/element.desktop`, (err) => {
        if(err) return console.log(err);
        console.log('file deleted successfully');
    })
};

if (isAutoStartEnabled()) {
    console.log("Updating autostart desktop file.");
    enableAutoStart();
}
