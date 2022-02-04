#!/bin/bash
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