##############################
# Latex - DO LAST/ OVER LUNCH
##############################

set -e

SETUP_DIR=$(pwd);

#Latex
cd ~/Downloads
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xzvf install-tl-unx.tar.gz
cd ~/Downloads/install-tl*
sudo ./install-tl

#Latexun
wget -O ~/bin/latexrun https://raw.githubusercontent.com/aclements/latexrun/master/latexrun
