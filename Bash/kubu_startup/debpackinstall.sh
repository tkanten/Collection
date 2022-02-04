#!/bin/bash

sudo apt-get install wget -y


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
echo "Login to Chrome, then close"
google-chrome

sudo dpkg -i syn*
echo "Enter key into Synergy, then close"
synergy


sudo dpkg -i parsec*
echo "Login to parsec, then close application"
parsecd

sudo dpkg -i VNC-Ser*
sudo systemctl start vncserver-virtuald.service
sudo systemctl enable vncserver-virtuald.service
echo "Login to VNC server, then press enter"
pkexec /etc/vnc/vncservice start vncserver-x11-serviced
read

sudo dpkg -i VNC-View*
echo "Login to VNC Viewer, then close the window"
vncviewer

# VMware package dependencies
sudo apt-get install gcc -y
sudo apt-get install build-essential -y

sudo sh VMware*
echo "Enter product key for VMware, then close"
vmware

echo "All done!"

cd ..
