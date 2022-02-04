#!/bin/bash
### THIS SCRIPT HAS BEEN TESTED ON KUBUNTU 21.10, NO GUARANTEE OF IT WORKING ELSEWHERE! ###
## MUST HAVE SNAP STORE ALREADY CONFIGURED!
#sudo apt-get install snapd-y
#sudo systemctl enable --now snapd.socket
#sudo snap refresh
## MUST ALSO HAVE APPARMOR!
#sudo apt-get install apparmor
#sudo systemctl enable --now apparmor.service

sudo apt-get update
sudo apt-get upgrade -y
sudo snap refresh

## script dependencies
sudo apt-get install git -y
sudo apt-get install curl -y

## programming languages, compilers, builders
sudo apt-get install manpages-dev -y
sudo apt-get install gcc-doc -y
sudo apt-get install gcc -y
sudo apt-get install make -y
sudo apt-get install gdb -y
sudo apt-get install python -y
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo apt-get install python3-disutils -y
sudo apt-get install python3-apt -y
sudo apt-get install nasm -y
sudo apt-get install ld -y
sudo apt-get install as -y
sudo apt-get install build-essentials -y

## cross compiling libs
#sudo apt install gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu -y
#sudo apt-get install gcc-arm* -y # 2GB

## IDE's
sudo snap install pycharm-community --classic
sudo snap install code --classic

## networking/web tools
sudo apt-get install net-tools -y
sudo apt-get install openvpn -y
sudo apt-get install curl -y
sudo apt-get install wireshark -y
sudo apt-get install sshpass -y

## helpful tools
sudo apt-get install ascii -y
sudo apt-get install tree -y
sudo apt-get install bless -y
sudo apt-get install htop -y
sudo apt-get install bat -y
echo "alias bat='batcat'" >> $HOME/.bashrc

## signal desktop
# install signals' public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

# add signal's repo to repository list
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
# update package database, install signal
sudo apt update && sudo apt install signal-desktop -y


## timeshift
sudo apt install timeshift
echo "It is recommended to use RSYNC for timeshift"
#TODO: swap to command line
sudo timeshift-gtk

## github SSH keygen setup
echo "Enter your Github email"
read githubEmail
ssh-keygen -t ed25519 -C "$githubEmail"
echo "Enter this SSH key into GitHub, hit Enter to continue"
cat ~/.ssh/id_ed25519
read