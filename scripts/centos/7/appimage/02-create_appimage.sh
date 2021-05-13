#!/bin/bash

set -eux 


export NODE_VERSION="16.x"
export SQLCIPHER_VERSION="4.4.3"
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


cd "$RT/_deps"

#if ! command -v sqlcipher &> /dev/null || [[ "$BUILD_DEPS" == "false" ]]
#then
#    status "Setting up sqlcipher"
#
#    # clone the source code of sqlcipher
#    git clone https://github.com/sqlcipher/sqlcipher
#    cd sqlcipher
#    git checkout "v$SQLCIPHER_VERSION"
#    ./configure --prefix=/usr --enable-tempstore=yes \
#        CFLAGS="-DSQLITE_HAS_CODEC" LDFLAGS="-lcrypto"
#    make
#    DESTDIR=/usr sudo make install
#fi


cd "$RT"

#curl --silent --location https://rpm.nodesource.com/setup_$NODE_VERSION | sudo bash -
#sudo yum -y install nodejs
#curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
#sudo rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
#sudo yum -y install yarn
#yarn --version
#node --version
#sudo yarn global add neon-cli
#neon version


cd "$RT"


status "Setting up Rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y -q
export PATH=$PATH:$HOME/.cargo/bin
cargo --version
rustc --version
source $HOME/.cargo/env



cd "$RT/_build"

status "Cloning Element Desktop"

git clone https://github.com/vector-im/element-desktop
cd element-desktop
git describe --tags
yarn install

yarn run fetch --noverify --cfgdir ''
yarn run docker:setup
yarn run docker:install
yarn run docker:build:native
yarn run docker:build

cp ../*.js src/.
cp ../patch.sh .
./patch.sh
yarn run electron-builder -l appimage --publish never
ls dist

mv dist/*.AppImage $RT/_dist/.
cd $RT/_dist/.

./*.AppImage --appimage-extract
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x ./appimagetool-x86_64.AppImage
rm Element*.AppImage
cp -L /usr/lib/libsqlcipher.so.0 squashfs-root/usr/lib/.
cp -L /lib64/libcrypto.so.10 squashfs-root/usr/lib/.
cp -L /lib64/libssl3.so squashfs-root/usr/lib/.
cp -L /lib64/libssl.so.10 squashfs-root/usr/lib/.
./appimagetool-x86_64.AppImage squashfs-root -n -u 'gh-releases-zsync|srevinsaju|element-appimage|continuous|Element*.AppImage.zsync' Element-`git describe --tags`-GLIBC-`ldd --version | grep 'ldd ' | grep -o ').[0-9].[0-9][0-9]' | grep -o '[0-9].[0-9][0-9]'`.AppImage
rm -r ./appimagetool-x86_64.AppImage
chmod +x *.AppImage
rm -rf squashfs-root




