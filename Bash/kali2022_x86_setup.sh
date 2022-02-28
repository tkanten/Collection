#!/bin/bash
## THIS SCRIPT HAS BEEN TESTED ON KALI 2022.1
## TO INSTALL:
# wget -O kali2022_x86_setup.sh https://raw.githubusercontent.com/tkanten/Collection/Programs/Bash/kali2022_x86_setup.sh
# chmod 777 kubu_x86_startup.sh

echo "Network driver download? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo apt install firmware-iwlwifi -y
    echo "Done! Rebooting! in 5 seconds..."
    sleep 5
    reboot
fi

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
    
    sudo apt-get install ascii tree bless htop bat -y
    echo "alias bat='batcat'" >> $HOME/.zshrc

    mkdir ~/Tools
    curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh >> ~/Tools/linpeas.sh
    curl -L https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php >> ~/Tools/php-revsh.php
    
    sudo apt-get install kali-linux-everything -y
    # unzipping rockyou
    sudo gzip -d /usr/share/wordlists/rockyou.txt.gz

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
    sudo systemctl enable --now snapd apparmor
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

echo "Install Synergy? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114194&authkey=AFfzFC4hjNZC4A0" -O synergy_1.14.2-stable.c6918b74_ubuntu21_amd64.deb
    sudo dpkg -i syn*
    rm syn*
    echo "Enter key into Synergy, then close the window\n"
    synergy

fi

echo "Install VMware? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21114201&authkey=AGmcq8OnUtOqigc" -O VMware-Workstation-Full-16.2.1-18811642.x86_64.bundle

    sudo sh VMware*

    # below fixes an unexpected issue with driver compilation of vmnet/vmmon
    # modify workstation version (after -b) to whatever version you're using
    git clone -b workstation-16.2.1 https://github.com/mkubecek/vmware-host-modules.git
    cd vmware-host-modules
    tar -cf vmmon.tar vmmon-only
    tar -cf vmnet.tar vmnet-only
    sudo cp -v vmmon.tar vmnet.tar /usr/lib/vmware/modules/source
    sudo vmware-modconfig --console --install-all
    cd ..
    rm -rf vmware-host-modules

    echo "Setup, add key, and close to continue!"
    vmware
fi

echo "Adjust zsh history length? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    echo "How big? (recommended no more than 10k)"
    read hsize
    sed "s,HISTSIZE=[^;]*,HISTSIZE=$hsize," -i ~/.zshrc
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

echo "Install Timeshift? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo apt install timeshift -y
    echo "It is recommended to use RSYNC for timeshift\n\n"
    sudo timeshift-gtk
fi

echo "Install KWIN quarter tiling? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    # https://github.com/Jazqa/kwin-quarter-tiling
    git clone https://github.com/Jazqa/kwin-quarter-tiling.git
    plasmapkg2 --type kwinscript -i kwin-quarter-tiling
    mkdir -p ~/.local/share/kservices5
    ln -sf ~/.local/share/kwin/scripts/quarter-tiling/metadata.desktop ~/.local/share/kservices5/kwin-script-quarter-tiling.desktop
    echo "Done! Go to kwin scripts in Settings, configure and enable Quarter Tiling (opening Settings in 5 seconds...)"
    sleep 5
    plasma-open-settings
    rm -rf kwin-quarter-tiling
fi

echo "Install Nessus? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    wget --no-check-certificate -c "https://onedrive.live.com/download?cid=409DBED65B684B08&resid=409DBED65B684B08%21120781&authkey=APMPrg1BwLoMq0U" -O Nessus-10.1.1-debian6_amd64
    sudo dpkg -i Nessus-10.1.1-debian6_amd64
    rm Nessus-10.1.1-debian6_amd64
    sudo systemctl start nessusd
    # enables nessus to start at boot
    sudo systemctl enable nessusd
    # opens webpage for nessus config
    xdg-open https://$HOST:8834
fi
echo "Setup complete!"
