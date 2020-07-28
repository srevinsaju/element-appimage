const fs = require('fs');
const os = require('os');
console.log("Element AppImage Build")
let pathToAppImage;
if (process.env.APPIMAGE == null) {
    pathToAppImage = "element-desktop";
} else {
    pathToAppImage = process.env.APPIMAGE;
};

function getDesktopFile(path) {
    return `[Desktop Entry]
Name=Element
Comment=A feature-rich client for Matrix
Exec=${path} %u
Terminal=false
Type=Application
Icon=element
StartupWMClass=element
Categories=Network;InstantMessaging;Chat;IRCClient
MimeType=x-scheme-handler/element;`

};


exports.isAutoStartEnabled = function isAutoStartEnabled() {
    if (fs.existsSync(`${os.homedir()}/.config/autostart/element.desktop`)) {
        return true;
    } else {
        return false;
    }    
};

exports.enableAutoStart = function enableAutoStart() {
    fs.writeFile(
        `${os.homedir()}/.config/autostart/element.desktop`,
        getDesktopFile(pathToAppImage), 
        function (err) {
            if (err) return console.log(err);
            console.log('Autostart desktop file');
        }
    );
};

exports.disableAutoStart = function disableAutoStart() {
    fs.unlink(`${os.homedir()}/.config/autostart/element.desktop`, (err) => {
        if(err) return console.log(err);
        console.log('file deleted successfully');
    })
};

