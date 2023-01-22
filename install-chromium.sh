#!/bin/bash
sudo apt update -y
sudo apt install software-properties-common -y
sudo echo "deb http://deb.debian.org/debian stable main" > /etc/apt/sources.list.d/debian.sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 605C66F00D6C9793
sudo apt update -y
sudo apt install chromium -y
sudo apt-key del 648ACFD622F3D138
sudo apt-key del 0E98404D386FA1D9
sudo apt-key del 605C66F00D6C9793
sudo rm -f /etc/apt/sources.list.d/debian.sources.list
sudo rm -f /etc/apt/trusted.gpg
sudo rm -f /etc/apt/trusted.gpg~
sudo rm -f /etc/apt/trusted.gpg.d/debian-archive*.gpg
sudo sed -i "s/chromium %U/chromium --no-sandbox --test-type %U/g" /usr/share/applications/chromium.desktop
