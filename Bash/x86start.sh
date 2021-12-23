#!/bin/bash
# this setup is good for x86
# change permissions to 777
# don't use sudo to execute
# wget -O x86start.sh https://raw.githubusercontent.com/tkanten/Collection/Programs/Bash/x86start.sh

sudo apt-get update -y
sudo apt-get upgrade -y 

sudo apt-get install manpages-dev -y
sudo apt-get install gcc-doc -y
sudo apt-get install gcc -y
sudo apt-get install make -y
sudo apt-get install gdb -y
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo apt-get install net-tools -y
sudo apt-get install nasm -y
sudo apt-get install ld -y
sudo apt-get install as -y
sudo apt-get install tree -y
sudo apt-get install bless -y
sudo apt-get install htop -y

# text editors
sudo apt-get install gedit -y

sudo apt-get install git -y
sudo apt-get install ascii -y

# optional ssh apps
#sudo apt-get install openssh-server -y
#sudo apt-get install sshpass -y

# better version of cat - best done manually
#sudo apt-get install bat
#mkdir -p ~/.local/bin
#ln -s /usr/bin/batcat ~/.local/bin/bat

# cross-compiling libs
#sudo apt install gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu -y
#sudo apt-get install gcc-arm* -y # 2GB

# apache2
#sudo apt-get install apache2 -y
#sudo service apache2 stop


# systems without snapd installed below

# install snap for pycharm (for debian based distros)
#sudo apt-get install snapd -y
#sudo systemctl enable --now snapd.socket
#sudo snap refresh

# installing pycharm
#sudo snap install pycharm-community --classic

# apparmor required to prevent pycharm-community picked up as a priv escalation false-positive
#sudo apt-get install apparmor
#sudo systemctl enable --now apparmor.service

# some versions of linux don't include these packages, needed for pycharm venv
#sudo apt-get install python3-distutils -y
#sudo apt-get install python3-apt -y


# installing visual studio code
#sudo snap install --classic code

# create a permanent env variable for snap
#export PATH=$PATH:/snap/bin
# now run pycharm with "pycharm-community" in terminal
