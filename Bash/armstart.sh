#!/bin/bash
# this setup is good for ARM
# change permissions to 777
# don't run as sudo
# wget -O armstart.sh https://raw.githubusercontent.com/tkanten/Collection/Programs/Bash/armstart.sh

# recommended to try update before, tends to be slow
sudo apt-get update -y
sudo apt-get upgrade -y 

sudo apt-get install wireshark -y
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

#gef install
wget -O ~/.gdbinit-gef.py -q https://github.com/hugsy/gef/raw/master/gef.py
echo source ~/.gdbinit-gef.py > ~/.gdbinit
echo "gef config context.show_registers_raw True" >> ~/.gdbinit

## OPTIONALS

# optional python modules for gef commands
#pip install keystone-engine
#pip install unicorn
#pip install capstone
#pip install ropper

# optional ssh apps
#sudo apt-get install openssh-server -y
#sudo apt-get install sshpass -y

# better version of cat - best done manually
#sudo apt-get install bat
#mkdir -p ~/.local/bin
#ln -s /usr/bin/batcat ~/.local/bin/bat

# apache2
#sudo apt-get install apache2 -y
#sudo service apache2 stop






