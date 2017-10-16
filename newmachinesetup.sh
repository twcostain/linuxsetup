###################################
# Script to set up a new computer
# (c) Theo Costain 2017
###################################

#############
# BASH SETUP
#############
cp ~/.bashrc ~/.bashrc.orig
if [ -f ~/.bash_aliases ]; then
    cp ~/.bash_aliases ~/.bash_aliases.orig
fi
cp bashrc ~/.bashrc
cp bash_aliases ~/.bash_aliases


################
# ESSESSENTIALS
################
sudo apt-get update
sudo apt-get install vim git python3
if [ ! -d ~/Downloads ]; then
    mkdir ~/Downloads
fi
if [ ! -d ~/Documents]; then
    mkdir ~/Documents
fi
if [ ! -d ~/bin ]; then
    mkdir ~/bin
fi

###############
# SSH
###############
ssh-keygen -t rsa -b 4096 -C $(uname -n)

###############
# GIT
###############
echo 'Setting global git config'
echo 'Please enter full name:'
read FULLNAME
git config --global user.name $FULLNAME
echo 'Please enter email for git:'
read GITEMAIL
git config --global user.name $GITEMAIL
git config --global core.editor vim

#############
# Python
#############
cd ~/Downloads
wget ~/Downloads https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
sudo pip install virtualenv virtualenvwrapper
sudo pip install --user numpy
pip completion -b >> ~/.profile

################
# Vim
################
git clone --depth=1 git://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

###############
# Sublime Text
###############
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

#################
# USEFULL THINGS
#################
sudo apt-get install evince

##################
# UBUNTU ARCTHEME
##################
if [[ `uname -v` == *"Ubuntu"* ]]; then
    #Theme
    sudo apt-get install autoconf automake pkg-config libgtk-3-dev gtk2-engine-murrine gnome-tweak-tool
    git clone https://github.com/horst3180/arc-theme --depth 1
    cd arc-theme
    ./autogen.sh --prefix=/usr --disable-light --disable-darker
    sudo make install

    #Icons
    git clone https://github.com/horst3180/arc-icon-theme --depth 1 && cd arc-icon-theme
    ./autogen.sh --prefix=/usr
    sudo make install
    sudo add-apt-repository ppa:moka/daily
    sudo apt-get install moka-icon-theme
    gnome-tweak-tool
fi

##############################
# Latex - DO LAST/ OVER LUNCH
##############################
cd Downloads
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xzvf install-tl-unx.tar.gz
cd install-tl*
sudo ./install-tl

cd ~/bin
wget http://https://raw.githubusercontent.com/aclements/latexrun/master/latexrun
