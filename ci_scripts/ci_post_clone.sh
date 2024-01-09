#!/bin/sh

#  ci_post_clone.sh
#  i-Inverter
#
#  Created by motech fae on 2024/1/9.
#

# Install CocoaPods using Homebrew.
 brew install cocoapods
 
# Install dependencies you manage with CocoaPods.
 pod install
