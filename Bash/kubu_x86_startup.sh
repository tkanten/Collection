#!/bin/bash
### THIS SCRIPT HAS BEEN TESTED ON KUBUNTU 21.10, NO GUARANTEE OF IT WORKING ELSEWHERE! ###
## MUST HAVE SNAP STORE ALREADY CONFIGURED!
#sudo apt-get install snapd-y
#sudo systemctl enable --now snapd.socket
#sudo snap refresh
## MUST ALSO HAVE APPARMOR!
#sudo apt-get install apparmor
#sudo systemctl enable --now apparmor.service
## TO INSTALL:
# wget -O kubu_x86_startup.sh https://raw.githubusercontent.com/tkanten/Collection/Programs/Bash/kubu_x86_startup.sh
# chmod 777 kubu_x86_startup.sh


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
sudo apt-get install build-essential -y

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
sudo apt-get install sshpass -y
sudo apt-get install wget -y

## helpful tools
sudo apt-get install ascii -y
sudo apt-get install tree -y
sudo apt-get install bless -y
sudo apt-get install htop -y
sudo apt-get install bat -y
echo "alias bat='batcat'" >> $HOME/.bashrc

## messaging
sudo snap install discord

## backups
sudo apt install timeshift -y

## signal desktop
# install signals' public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

# add signal's repo to repository list
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
# update package database, install signal
sudo apt update && sudo apt install signal-desktop -y

### DEB PACKAGE DOWNLOADING ###
mkdir Deb_Packages
cd Deb_Packages
# installing packages
# steps downloading from onedrive:
#	1. share file for all (set as view only)
#	2. go to browser version, right click and select "Embed", generate embed
#	3. copy embed, take link, replace embed with download in link
#	4. profit
wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114198&authkey=APuAmu_iX5UzpZ4" -O google-chrome-stable_current_amd64.deb
wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114195&authkey=AKP6ADCvcf4QAxs" -O parsec-linux.deb
wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114194&authkey=AFfzFC4hjNZC4A0" -O synergy_1.14.2-stable.c6918b74_ubuntu21_amd64.deb
wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114197&authkey=ANf-im-5wDTO588" -O teams_1.4.00.26453_amd64.deb
wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114201&authkey=AGmcq8OnUtOqigc" -O VMware-Workstation-Full-16.2.1-18811642.x86_64.bundle
wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114200&authkey=AIGNHxJRoqReDZg" -O VNC-Server-6.8.0-Linux-x64.deb
wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114199&authkey=AADpSiFvHLHWaU4" -O VNC-Viewer-6.21.1109-Linux-x64.deb


sudo dpkg -i google-chrome*
sudo dpkg -i syn*
sudo dpkg -i parsec*
sudo dpkg -i VNC-Ser*
sudo dpkg -i VNC-View*
sudo sh VMware*

echo "Next part will require console interaction, press enter to continue"
read

### EVERYTHING BELOW REQUIRES USER INTERACTION!
sudo apt-get install wireshark -y

## timeshift config
echo "It is recommended to use RSYNC for timeshift"
#TODO: swap to command line
sudo timeshift-gtk

## github SSH keygen setup
echo "Enter your Github email"
read githubEmail
ssh-keygen -t ed25519 -C "$githubEmail"
echo "Enter this SSH public key into GitHub, hit Enter to continue"
cat ~/.ssh/id_ed25519.pub
read

echo "Login to Chrome, then close the window"
google-chrome
echo "Enter product key for VMware, then close the window"
vmware
echo "Enter key into Synergy, then close the window"
synergy

echo "Login to VNC Viewer, then close the window"
vncviewer
echo "Login to Parsec, then close application"
parsecd
echo "Login to VNC server, then press enter"
pkexec /etc/vnc/vncservice start vncserver-x11-serviced
read
sudo systemctl start vncserver-virtuald.service
sudo systemctl enable vncserver-virtuald.service

cd ..

echo "Login to Signal, then close application"
signal-desktop
echo "Login to Discord, then close application"
discord


### ZSH SHELL ###
## guides used:
# https://www.initpals.com/linux/installing-and-configuring-kde-konsole-with-oh-my-zsh-in-kubuntu/
# https://linuxhint.com/enable-syntax-highlighting-zsh/
# dependancy installation
sudo apt-get install curl -y
sudo apt-get install git -y
sudo apt-get install zsh -y

# changing shell, installing ohmyzsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# syntax highlighting as plugin
zsh -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# modifying zsh theme
sed 's,ZSH_THEME=[^;]*,ZSH_THEME="jonathan",' -i ~/.zshrc
# adding syntax highlighting
sed 's,plugins=[^;]*,plugins=(git zsh-syntax-highlighting),' -i ~/.zshrc
echo "alias bat='batcat'" >> $HOME/.zshrc

zsh -c "source ~/.zshrc"

## cleanup
rm -rf Deb_Packages/*
rmdir Deb_Packages
sudo apt autoremove -y
rm kubu_x86_startup.sh
