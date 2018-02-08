##################
# UBUNTU ARCTHEME
##################

set -e

SETUP_DIR=$(pwd);

#Theme
sudo apt-get install autoconf automake pkg-config libgtk-3-dev gtk2-engine-murrine gnome-tweak-tool
cd ~/Downloads
git clone https://github.com/horst3180/arc-theme --depth 1
cd arc-theme
./autogen.sh --prefix=/usr --disable-light --disable-darker
sudo make install

#Icons
cd ~/Downloads
git clone https://github.com/horst3180/arc-icon-theme --depth 1 && cd arc-icon-theme
./autogen.sh --prefix=/usr
sudo make install
sudo add-apt-repository ppa:moka/daily
sudo apt-get install moka-icon-theme
gnome-tweak-tool
