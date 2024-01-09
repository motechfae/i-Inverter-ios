#!/bin/sh

#  ci_post_clone.sh
#  i-Inverter
#
#  Created by motech fae on 2024/1/9.
#

echo "开始安装cocoapods"
brew install cocoapods
echo "cocoapods安装完毕"
echo "开始设置cocoapods"
pod setup
echo "cocoapods设置完毕"
echo "开始安装pods依赖库"
pod install
echo "pods依赖库安装完毕"
