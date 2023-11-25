#!/usr/bin/env bash

# Setup environment
mkdir ~/bin
PATH=~/bin:$PATH
cd ~/bin
apt update -y
apt install curl -y
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
git clone https://github.com/eartinity/scripts.git scripts
cd scripts
bash setup/android_build_env.sh

# Sync Source
git config --global user.name "eartinity" && git config --global user.email "priyaranjan24samal@gmail.com"
mkdir pe && cd pe
repo init https://github.com/PixelExperience/manifest.git -b thirteen -y
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# Sync Trees
git clone  https://github.com/eartinity/device_realme_r5x device/realme/r5x -b pe
git clone  https://github.com/eartinity/vendor_realme_r5x vendor/realme/r5x -b thirteen
git clone  https://github.com/eartinity/kernel_realme_trinket -b labs-dynamic kernel/realme/r5x

# Start Build
source build/envsetup.sh
lunch aosp_r5x-userdebug
make bacon -j$(nproc --all)

# Upload
cd out/target/product/r5x
curl -sL https://git.io/file-transfer | sh
./transfer wet aosp*.zip￼Enter
