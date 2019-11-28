###################################
# Script to set up a linux box
# (c) Theo Costain 2019
###################################

set -e # Don't blindly continue after an error


SETUP_DIR=$(pwd);

PACKAGE_LIST="packages.txt"
SNAP_LIST="snaps.txt"

# Install desired packages and snaps
install_core_packages(){
    sudo -v # Check that we have sudo permission
    
    echo "Installing packages from packages.txt"
    local PROGRAMS="$(cat core_packages.txt)"
    sudo apt update
    while read PROG; do
        sudo apt -qq install $PROG
    done < $_LIST
}

install_snaps(){
    sudo -v #Check that we have sudo permission

    echo "Installing packages from snaps.txt"
    local SNAPS="$(cat snaps.txt)"
    while read SNAP; do
        sudo snap install $SNAP
    done < $_LIST
}

install_miniconda(){
    wget -Lo /tmp/miniconda_install.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash /tmp/miniconda_install.sh
    conda config --set auto_activate_base false
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
    if [[ ! -z $(which zsh) ]] && [[ $SHELL != $(which zsh) ]]; then
        local CUSTOM="~/.oh-my-zsh/custom/"
        chsh -s $(which zsh)
        curl -Lo /tmp/oh_my_zsh_install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
        sh /tmp/oh_my_zsh_install.sh
        if [[! -f $CUSTOM/aliases.zsh ]]; then
            cp $SETUP_DIR/dotfiles/aliases.zsh $CUSTOM/aliases.zsh
        fi

        if [[! -f $CUSTOM/rc.zsh ]]; then
            cp $SETUP_DIR/dotfiles/rc.zsh $CUSTOM/rc.zsh
        fi
    else
        echo "Zsh not installed or already SHELL."
    fi
}

gen_ssh_key(){
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        ssh-keygen -t ed25519 -C "$(whoami)@$(uname -n)"
    fi
}

configure_home(){
    if [[ ! -d ~/Downloads ]]; then
        mkdir ~/Downloads
    fi
    if [[ ! -d ~/bin ]]; then
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


core_install_sudo(){
    install_core_packages || echo "Installing Packages failed."
}

install_sudo(){
    core_install_sudo
    install_snaps || echo "Installing Snaps failed."
}

core_install_nosudo(){
    install_miniconda || echo "Installing miniconda failed."
}

install_nosudo(){
    core_install_nosudo
}

core_configure(){
    configure_zsh || echo "Failed to configure zsh."
    configure_git || echo "Failed to configure git."
    configure_home || echo "Failed to configure home directory."
    configure_vim || echo "Failed to configure vim."
    configure_tmux || echo "Failed to configure tmux."
}

configure(){
    core_configure
}

main(){
    install_sudo
    install_nosudo
    configure
}

headless(){
    core_install_sudo
    core_configure
}

headless_nosudo(){
    core_install_sudo
    core_configure
}

cat install_options.txt

read -p "Choose an option:" -n 1 -r OPTION
echo
case $OPTION in
    1)
        main
        ;;
    2)
        configure
        ;;
    3)
        install_miniconda || echo "Installing miniconda failed."
        configure
        ;;
    4)
        headless
        ;;
    5)
        headless_nosudo
        ;;
    *)
        echo "Please choose a valid option"
        exit 1
        ;;
esac