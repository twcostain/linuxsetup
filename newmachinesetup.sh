###################################
# Script to set up a new computer
# (c) Theo Costain 2017
###################################

set -e

#############
# BASH SETUP
#############
SETUP_DIR=$(pwd);

if [ -f ~/.bashrc ]; then
	cp ~/.bashrc ~/.bashrc.orig
fi
if [ -f ~/.bash_aliases ]; then
    cp ~/.bash_aliases ~/.bash_aliases.orig
fi
cp $SETUP_DIR/dotfiles/bashrc ~/.bashrc
cp $SETUP_DIR/dotfiles/bash_aliases ~/.bash_aliases


################
# ESSESSENTIALS
################
sudo apt-get update
sudo apt install vim git python3
if [ ! -d ~/Downloads ]; then
    mkdir ~/Downloads
fi
if [ ! -d ~/Documents ]; then
    mkdir ~/Documents
fi
if [ ! -d ~/bin ]; then
    mkdir ~/bin
fi

###############
# SSH
###############
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(uname -n)"
fi

###############
# GIT
###############
echo 'Setting global git config'
echo 'Please enter full name:'
read FULLNAME
git config --global user.name $FULLNAME
echo 'Please enter email for git:'
read GITEMAIL
git config --global user.email $GITEMAIL
git config --global core.editor vim

#############
# Python
#############
wget -O ~/Downloads/get-pip.py https://bootstrap.pypa.io/get-pip.py
sudo python3 ~/Downloads/get-pip.py
pip3 completion -b >> ~/.profile

pip3 install --user numpy pandas matplotlib
sudo -H pip3 install virtualenv virtualenvwrapper

################
# Vim
################
git clone --depth=1 git://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
cat $SETUP_DIR/dotfiles/vimrcadditions >> ~/.vim_runtime/my_configs.vim

##########
# Tmux
##########
sudo apt install tmux
cp $SETUP_DIR/dotfiles/tmux.conf ~/.tmux.conf

#################
# USEFULL THINGS
#################
sudo apt install evince tree htop


