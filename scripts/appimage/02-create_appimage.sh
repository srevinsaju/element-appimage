#!/bin/bash

set -eux 

export APPIMAGE_EXTRACT_AND_RUN=1

if [ -z ${BUILD_DEPS+x} ]
then
    export BUILD_DEPS="true"
fi


echo ""

ls -al

mkdir -p _deps 
mkdir -p _build
mkdir -p _release


status () {
    echo "========================="
    echo -e "\033[31;1;4m$1\033[0m"
    echo "========================="
}

export RT="$PWD"

cd "$RT/_build"

status "Cloning Element Desktop"

git clone https://github.com/element-hq/element-desktop
cd element-desktop
if [[ "$BUILD_TYPE" == "stable" ]]; then
    git checkout `curl --silent -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/element-hq/element-desktop/releases/latest | jq  -r '.tag_name'`
fi
git describe --tags --always --match "v*.*"
export ELEMENT_BUILD_VERSION="$(git describe --tags --always --match 'v*.*')"
yarn install

sed -i 's,docker run --rm -ti,docker run --rm,g' scripts/in-docker.sh
mkdir -p appimage_config
pushd appimage_config
if [[ "$BUILD_DEPS" == "stable" ]]; then 
  wget https://app.element.io/config.json 
else
  wget https://develop.element.io/config.json
fi
popd

yarn run fetch --noverify --cfgdir 'appimage_config'
yarn run docker:setup

cp $RT/*.ts src/.
cp $RT/patch.sh .
./patch.sh

yarn run docker:install < /dev/null
yarn run docker:build:native
yarn run docker:build
./scripts/in-docker.sh yarn run electron-builder -l appimage --publish never

ls dist

mkdir -p $RT/_dist/.
sudo chmod o+rwx dist/*.AppImage
sudo mv dist/*.AppImage $RT/_dist/.
sudo chown `whoami`:`whoami` $RT/_dist/*.AppImage
cd $RT/_dist/.

./*.AppImage --appimage-extract
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x ./appimagetool-x86_64.AppImage
sudo rm -rf Element*.AppImage

#cp -L /usr/lib/libsqlcipher.so.0 squashfs-root/usr/lib/.
#cp -L /lib64/libcrypto.so.10 squashfs-root/usr/lib/.
#cp -L /lib64/libssl3.so squashfs-root/usr/lib/.
#cp -L /lib64/libssl.so.10 squashfs-root/usr/lib/.
./appimagetool-x86_64.AppImage squashfs-root -n -u 'gh-releases-zsync|srevinsaju|element-appimage|continuous|Element*.AppImage.zsync' Element-$ELEMENT_BUILD_VERSION.glibc`ldd --version | grep 'ldd ' | grep -o ').[0-9].[0-9][0-9]' | grep -o '[0-9].[0-9][0-9]'`.AppImage
rm -r ./appimagetool-x86_64.AppImage
chmod +x *.AppImage
rm -rf squashfs-root




