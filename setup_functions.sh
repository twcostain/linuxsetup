SETUP_DIR=$(pwd);

# Install desired packages and snaps
install_core_packages(){
    set -e
    sudo -v # Check that we have sudo permission
    # check if we have aptitude (i.e. debian or ubuntu system)
    if [[ ! -z $(which apt) ]]; then
        echo "Installing packages from core_apt_packages.txt"
        sudo apt update
        while read PROG; do
            sudo apt -qq -y install $PROG
        done < core_packages.txt
    fi
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
    # New git config improvements
    git config --global branch.sort -committerdate
    git config --global diff.algorithm histogram
    git config --global diff.colorMoved plain
    git config --global diff.renames true
    git config --global fetch.prune true\ngit config --global fetch.pruneTags true\ngit config --global fetch.all true
    git config --global help.autocorrect prompt
    git config --global merge.conflictstyle zdiff3
    git config --global color.ui auto
    git config --global alias.l "log --all --decorate --oneline --graph"
    return
}

configure_zsh(){
    set -e
    # TODO handle case where zsh installed (i.e. MacOS) but no oh-my-zsh
    if [[ ! -z $(which zsh) ]] && [[ $SHELL != $(which zsh) ]]; then
        local CUSTOM=$HOME/.oh-my-zsh/custom
        wget -O /tmp/oh_my_zsh_install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
        RUNZSH=no sh /tmp/oh_my_zsh_install.sh
        
        cp $SETUP_DIR/dotfiles/rc.zsh $HOME/.zshrc
        if [[ ! -f $CUSTOM/aliases.zsh ]]; then
            cp $SETUP_DIR/dotfiles/aliases.zsh $CUSTOM/aliases.zsh
        fi

        return 0
    else
        echo "Zsh not installed or already SHELL."
        return 1
    fi
    return
}

configure_ssh_key(){
    # TODO 1password compat?
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
    echo "##########\nDONT FORGET TO EDIT BASIC.VIM IF YOU WANT TO CHANGE LEADER!!!!\n##########"
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
    return
}

main(){
    install_sudo
    configure
    return
}

headless(){
    core_install_sudo
    core_configure
    return
}

headless_nosudo(){
    core_configure
    return
}
