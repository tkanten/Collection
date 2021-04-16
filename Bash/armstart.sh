#!/bin/bash
#this setup is good for ARM
#change permissions to 777
#wget -O armstart.sh https://raw.githubusercontent.com/tkanten/Collection/Programs/Bash/armstart.sh
#NOTE: MAY NEED TO USE "export LC_CTYPE=C.UTF-8"

sudo apt-get update -y
sudo apt-get upgrade -y 

#below this line is fully automatic
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

#gef install
wget -O ~/.gdbinit-gef.py -q http://gef.blah.cat/py
echo source ~/.gdbinit-gef.py > ~/.gdbinit
echo "gef config context.show_registers_raw True" >> ~/.gdbinit
#additional python modules for gef commands
pip install keystone-engine
pip install unicorn
pip install capstone
pip install ropper

