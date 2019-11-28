
# Install desired packages and snaps
install_core_packages(){
    set -e
    sudo -v # Check that we have sudo permission
    
    echo "Installing packages from core_packages.txt"
    sudo apt update
    while read PROG; do
        sudo apt -qq install $PROG
    done < core_packages.txt
    return
}

install_snaps(){
    set -e
    sudo -v #Check that we have sudo permission

    echo "Installing packages from snaps.txt"
    while read SNAP; do
        sudo snap install $SNAP
    done < snaps.txt
    return
}

install_miniconda(){
    set -e
    wget -O /tmp/miniconda_install.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash /tmp/miniconda_install.sh
    conda config --set auto_activate_base false
    return 
}

install_latex(){
    set -e
    wget -O /tmp/install-tl-unx.tar.gz http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    tar xzvf install-tl-unx.tar.gz
    cd /tmp/install-tl*
    sudo ./install-tl

    tlmgr init-usertree
    return
}

configure_git(){
    set -e
    echo 'Setting global git config'
    echo 'Please enter full name:'
    read FULLNAME
    git config --global user.name $FULLNAME
    echo 'Please enter email for git:'
    read GITEMAIL
    git config --global user.email $GITEMAIL
    git config --global core.editor vim
    return
}

configure_zsh(){
    set -e
    if [[ ! -z $(which zsh) ]] && [[ $SHELL != $(which zsh) ]]; then
        local CUSTOM="~/.oh-my-zsh/custom/"
        wget -O /tmp/oh_my_zsh_install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
        RUNZSH=no sh /tmp/oh_my_zsh_install.sh
        if [[ ! -f $CUSTOM/aliases.zsh ]]; then
            cp $SETUP_DIR/dotfiles/aliases.zsh $CUSTOM/aliases.zsh
        fi

        if [[ ! -f $CUSTOM/rc.zsh ]]; then
            cp $SETUP_DIR/dotfiles/rc.zsh $CUSTOM/rc.zsh
        fi
    else
        echo "Zsh not installed or already SHELL."
    fi
    return
}

configure_ssh_key(){
    set -e
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        ssh-keygen -t ed25519 -C "$(whoami)@$(uname -n)"
    fi
    return
}

configure_home(){
    set -e
    if [[ ! -d ~/Downloads ]]; then
        mkdir ~/Downloads
    fi
    if [[ ! -d ~/bin ]]; then
        mkdir ~/bin
    fi
    return
}

configure_tmux(){
    set -e
    cp $SETUP_DIR/dotfiles/tmux.conf ~/.tmux.conf
    return
}

configure_vim(){
    set -e
    git clone --depth=1 git://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    cat $SETUP_DIR/dotfiles/vimrcadditions >> ~/.vim_runtime/my_configs.vim
    return
}

configure_vscode(){
    set -e
    if [[ ! -z $(which code) ]];then
        # install extensions
        while read EXT; do
            code --install-extension $EXT
        done < vscode_extensions.txt
    fi
    return
}


core_install_sudo(){
    install_core_packages || echo "Installing Packages failed."
    return
}

install_sudo(){
    core_install_sudo
    install_snaps || echo "Installing Snaps failed."
    return
}

core_install_nosudo(){
    install_miniconda || echo "Installing miniconda failed."
    return
}

install_nosudo(){
    core_install_nosudo
    return
}

core_configure(){
    configure_zsh || echo "Failed to configure zsh."
    configure_ssh_key || echo "Failed to configure ssh key."
    configure_git || echo "Failed to configure git."
    configure_home || echo "Failed to configure home directory."
    configure_vim || echo "Failed to configure vim."
    configure_tmux || echo "Failed to configure tmux."
    return
}

configure(){
    core_configure
    configure_vscode || echo "Failed to configure vscode."
    return
}

main(){
    install_sudo
    install_nosudo
    configure
    return
}

headless(){
    core_install_sudo
    core_configure
    return
}

headless_nosudo(){
    core_install_nosudo
    core_configure
    return
}
