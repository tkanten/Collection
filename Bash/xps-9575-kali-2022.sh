#sudo apt-get update
#sudo apt-get upgrade

# NOTE - this wireless driver installations ection is manual
# sudo apt-get install firmware-realtek firmware-misc-nonfree
# should see QCA6174
# sudo lspci | grep -i qca6174
# mkdir linux-firmware && cd linux-firmware
# git clone https://github.com/kvalo/ath10k-firmware.git
# sudo cp -R ath10k-firmware/QCA6174 /lib/firmware/ath10k
# based on dmesg errors, we'll need to change stuff.
# on xps 9575, copy /lib/firmware/ath10k/QCA6174/hw3.0/firmware-4.bin_WLAN.RM.2.0-00180-QCARMSWPZ-1 to firmware-4.bin
# sudo cp /lib/firmware/ath10k/QCA6174/hw3.0/2.0/firmware-4.bin_WLAN.RM.2.0-..... to /lib/firmware/ath10k/QCA6174/hw3.0/firmware-4.bin
# Note: there are still device errors, however it appears to be workingt
# sudo dmesg | grep ath10k

echo "Plasma download/install? (reboot req) [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    echo "Ensure 'sddm' is selected!"
    sleep 2
    sudo apt-get install kali-desktop-kde -y
    echo "Ensure you select plasma!"
    sudo update-alternatives --config x-session-manager
    echo "Done! Rebooting in 5 seconds..."
    sleep 5
    reboot
fi

echo "Remove xfce? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo apt purge --autoremove kali-desktop-xfce -y
    echo "Done!"
fi

echo "Install all tools? (reboot req) [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    echo "Before continuing, adjust any settings to disable screen locking/timeout - this will take a while! Press anything to continue"
    read
    
    sudo apt-get install ltrace ascii tree bless htop bat zenmap-kbx libreoffice -y
    echo "alias bat='batcat'" >> $HOME/.zshrc
    
    mkdir ~/Tools
    curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh >> ~/Tools/linpeas.sh
    curl -L https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php >> ~/Tools/php-revsh.php
    
    sudo apt-get install kali-linux-everything -y
    # unzipping rockyou
    sudo gzip -d /usr/share/wordlists/rockyou.txt.gz
    
    # bare metal build doesn't start bluetooth service, restarting seems to do the trick
    sudo systemctl enable bluetooth
    sudo service bluetooth restart

    echo "Done install! Rebooting in 5 seconds..."
    sleep 5
    reboot
fi

echo "Install VNC Server/Viewer? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo apt remove tightvncserver -y
    sudo apt remove xtightvncviewer -y
    wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114200&authkey=AIGNHxJRoqReDZg" -O VNC-Server-6.8.0-Linux-x64.deb
    wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114199&authkey=AADpSiFvHLHWaU4" -O VNC-Viewer-6.21.1109-Linux-x64.deb
    sudo dpkg -i VNC-Viewer-6.21.1109-Linux-x64.deb

    sudo dpkg -i VNC-Server-6.8.0-Linux-x64.deb
    echo "Login to VNC server, then press enter"
    pkexec /etc/vnc/vncservice start vncserver-x11-serviced
    read
    sudo systemctl start vncserver-x11-serviced.service
    sudo systemctl enable vncserver-x11-serviced.service 


    echo "Login to VNC Viewer, then press enter"
    vncviewer

    rm VNC-Viewer-6.21.1109-Linux-x64.deb
    rm VNC-Server-6.8.0-Linux-x64.deb
fi

echo "Setup Github SSH? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    echo "Enter your Github email"
    read githubEmail
    echo "Enter your Github username"
    read githubUsername
    ssh-keygen -t ed25519 -C "$githubEmail"
    echo "Enter this SSH public key into GitHub, hit Enter to continue"
    cat ~/.ssh/id_ed25519.pub
    read
    ssh-add ~/.ssh/id_ed25519
    git config --global user.email "$githubEmail"
    git config --global user.name "$githubUsername"
fi

echo "Install gdb/gef? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo apt remove gdb -y
    sudo apt-get install gdb -y
    wget -O ~/.gdbinit-gef.py -q https://github.com/hugsy/gef/raw/master/gef.py
    echo source ~/.gdbinit-gef.py > ~/.gdbinit
    echo "set disassembly-flavor intel" >> ~/.gdbinit
    echo "gef config context.show_registers_raw True" >> ~/.gdbinit
    pip3 install keystone-engine unicorn
    echo "Done! Check if it works!\n\n"
    gdb
fi

echo "Install snapd/plasma backend? (reboot req) [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo apt-get install snapd -y
    sudo systemctl enable --now snapd.apparmor
    sudo apt-get install plasma-discover-backend-snap -y
    echo "Add snap to settings in Discover\n\n"
    plasma-discover
    echo "Done! Rebooting in 5 seconds..."
    sleep 5
    reboot
fi

echo "Install snap apps? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo service snapd start
    sudo snap refresh
    sudo snap install pycharm-community --classic
    sudo snap install code --classic
    sudo snap install discord

    echo "Login to Discord, then close application"
    discord
fi

echo "Install Parsec? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114195&authkey=AKP6ADCvcf4QAxs" -O parsec-linux.deb
    sudo dpkg -i parsec-linux.deb
    rm parsec-linux.deb
    echo "Login, then close to continue"
    parsecd
fi

echo "Install Signal? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    # install signals' public software signing key
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

    # add signal's repo to repository list
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
    sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
    # update package database, install signal
    sudo apt update && sudo apt install signal-desktop -y
    echo "Login to Signal, then close application"
    signal-desktop
fi

echo "Install Docker? [Y,n"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo apt update
    sudo apt install docker.io -y
    sudo systemctl enable docker --now
    sudo systemctl enable docker.service
    sudo usermod -aG docker $USER
fi

echo "Install Timeshift? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo apt install timeshift -y
    echo "It is recommended to use RSYNC for timeshift\n\n"
    sudo timeshift-gtk
fi

echo "Setup complete!"
