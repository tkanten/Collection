#!/bin/bash
#this setup is good for ARM
#change permissions to 777
#don't run as sudo
#wget -O armstart.sh https://raw.githubusercontent.com/tkanten/Collection/Programs/Bash/armstart.sh

#recommended to try update before, tends to be slow
sudo apt-get update -y
sudo apt-get upgrade -y 

#sometimes no default language is set on ARM, these lines will fix that (if needed)
#sudo dpkg-reconfigure locales # select US english UTF8
#sudo localedef -i en_US -c -f UTF-8 en_US.UTF-8
#re-writes locale file w/ new parameters
#sudo echo -e "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8\nLANGUAGE=en.US.UTF-8" > /etc/default/locale


#below this line is fully automatic
sudo apt-get install whois -y
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
sudo apt-get install john -y
sudo apt-get install gedit -y
sudo apt-get install git -y
sudo apt-get install ascii -y
sudo apt-get install openssh-server -y
sudo apt-get install bat
#re-assign executable name from batcat to bat
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

#gef install
wget -O ~/.gdbinit-gef.py -q http://gef.blah.cat/py
echo source ~/.gdbinit-gef.py > ~/.gdbinit
echo "gef config context.show_registers_raw True" >> ~/.gdbinit

#optional python modules for gef commands
#pip install keystone-engine
#pip install unicorn
#pip install capstone
#pip install ropper

