###################################
# Script to set up a linux box
# (c) Theo Costain 2019
###################################

set -e # Don't blindly continue after an error

sudo -v # Check that we have sudo permission

SETUP_DIR=$(pwd);

PACKAGE_LIST="packages.txt"
SNAP_LIST="snaps.txt"

# Install desired packages and snaps
install_packages(){
    echo "Installing packages from packages.txt"
    PROGRAMS="$(cat packages.txt)"
    sudo apt update
    while read PROG; do
        sudo apt -qq install $PROG
    done < $_LIST

    echo "Installing packages from snaps.txt"
    SNAPS="$(cat snaps.txt)"
    while read SNAP; do
        sudo snap install $SNAP
    done < $_LIST
}

configure_git(){
    echo 'Setting global git config'
    echo 'Please enter full name:'
    read FULLNAME
    git config --global user.name $FULLNAME
    echo 'Please enter email for git:'
    read GITEMAIL
    git config --global user.email $GITEMAIL
    git config --global core.editor vim
}

configure_zsh(){
    CUSTOM="~/.oh-my-zsh/custom/"
    chsh -s $(which zsh)
    curl -Lo /tmp/oh_my_zsh_install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    sh /tmp/oh_my_zsh_install.sh
    if [ ! -f $CUSTOM/aliases.zsh]
    cp $SETUP_DIR/dotfiles/aliases.zsh $CUSTOM/aliases.zsh
}

gen_ssh_key(){
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        ssh-keygen -t ed25519 -C "$(whoami)@$(uname -n)"
    fi
}

configure_home(){
    if [ ! -d ~/Downloads ]; then
        mkdir ~/Downloads
    fi
    if [ ! -d ~/bin ]; then
        mkdir ~/bin
    fi
}

configure_tmux(){
    cp $SETUP_DIR/dotfiles/tmux.conf ~/.tmux.conf
}

configure_vim(){
    git clone --depth=1 git://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    cat $SETUP_DIR/dotfiles/vimrcadditions >> ~/.vim_runtime/my_configs.vim
}


main_install(){
    install_packages || echo "Installing Packages failed. Continuing with configurations"
}

main_configure(){
    configure_zsh || echo "Failed to configure zsh."
    configure_tmux || echo "Failed to configure tmux."
}

main(){
    main_install
    main_configure
}

read -p "Attempt Installation and configuration" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    main
    exit
fi

read -p "Commence configuration only?" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    main_configure
    exit
fi