packages_from_github() {
    declare -a PACKAGES_FROM_GITHUB

    PACKAGES_FROM_GITHUB[0]="sstephenson/bats"           # tests in bash
    PACKAGES_FROM_GITHUB[1]="freakhill/scripts"          # my script
    PACKAGES_FROM_GITHUB[2]="fidian/ansi"                # colors and window title
    PACKAGES_FROM_GITHUB[3]="clvv/fasd"                  # File Any Search Dir
    PACKAGES_FROM_GITHUB[4]="junegunn/fzf"               # fuzzy file finder
    PACKAGES_FROM_GITHUB[5]="paoloantinori/hhighlighter" # highlights
    PACKAGES_FROM_GITHUB[6]="shyiko/commacd"             # ,(forward) ,,(back) ,,,(both)
    PACKAGES_FROM_GITHUB[7]="tests-always-included/mo"   # moustache templates in bash

    echo ${PACKAGES_FROM_GITHUB[@]}
}

restow() {
        stow -d $PEARL_PKGVARDIR -t $HOME/.local -R $1
}

idem_install() {
    info "idempotent install"
    ############################################################################
    info "installing pearl packages"
    try pearl install liquidprompt ls-colors
    ############################################################################
    info "installing cargo packages"
    ! type -a racer && cargo install racer
    ! type -a parallel && cargo install parallel
    ! type -a rg && cargo install ripgrep
    ############################################################################
    info "installing guix packages"
    ! type -a go && guix package -i go
    ! type -a ruby && guix package -i ruby
    ### guix node package is broken so we install with stow
    #guix package -i node
    info "installing nodejs"
    if ! type -a npm
    then
        mkdir -p $HOME/.stow
        pushd $PEARL_PKGVARDIR
        wget https://nodejs.org/dist/v6.9.3/node-v6.9.3-linux-x64.tar.xz
        tar xf node-v6.9.3-linux-x64.tar.xz
        rm node-v6.9.3-linux-x64.tar.xz
        restow node-v6.9.3-linux-x64
        popd
    fi
    restow_node() {
        restow node-v6.9.3-linux-x64
    }
    ############################################################################
    info "installing npm packages"
    ! type -a tldr && npm install -g tldr && restow_node
    ############################################################################
    info "installing rq"
    pushd $HOME/.local/bin
    if ! type -a rq
    then
        curl -fsSLo rq https://s3-eu-west-1.amazonaws.com/record-query/record-query/x86_64-unknown-linux-musl/rq
        chmod +x rq
    fi
    ############################################################################
    info "installing lein"
    if ! type -a lein
    then
        pushd ~/.local/bin
        curl -fsSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > lein
        chmod +x lein
        ./lein
        popd
    fi
}

install_from_github() {
    local dir="${PEARL_PKGVARDIR}/$1"
    if ! [ -d "$dir" ]
    then
        info "installing from github $1"
        mkdir -p "$dir/.."
        pushd "$dir/.."
        git clone https://github.com/$1
        info "stowing links from $dir/.. :: $(echo $1 | cut -f2 -d'/')"
        stow -d "$dir/.." -t $HOME/.local $(echo "$1" | cut -f2 -d'/')
        popd
    else
        info "skipping install from github $1"
    fi
}

update_from_github() {
    local dir="${PEARL_PKGVARDIR}/$1"
    info "updating from github $1"
    pushd "$dir"
    git pull
    stow -d "$dir/.." -t $HOME/.local -R $(echo "$1" | cut -f2 -d'/')
    popd
}

post_install() {
    mkdir -p $HOME/.local/{bin,etc,run,lib,share,var/log}
    mkdir -p $HOME/.go

    for pkg in `packages_from_github`
    do
        install_from_github $pkg
    done

    info "running fzf install script"
    ( $PEARL_PKGVARDIR/junegunn/fzf/install )

    info "make sur that our homemade ssh/scp scripts run fine"
    mkdir -p $HOME/.ssh/config.0
    mkdir -p $HOME/.ssh/backups
    touch $HOME/.ssh/config.0/empty
    touch $HOME/.ssh/settings
    touch $HOME/.ssh/config
    chmod 600 $HOME/.ssh/config

    [ "$(ls -A $HOME/.ssh/config.0)" ] && info "config.0 not empty" \
            || cp $HOME/.ssh/config $HOME/.ssh/config.0/oldconfig

    info "link tmux and git config"
    rm -f $HOME/.tmux.conf
    rm -f $HOME/.gitconfig
    ln -s "$PEARL_PKGDIR/tmux.conf" $HOME/.tmux.conf
    ln -s "$PEARL_PKGDIR/gitconfig" $HOME/.gitconfig

    info "adding bashrc source to bash_profile for ssh"
    printf "\n[ -f ~/.bashrc ] && source ~/.bashrc\n" >> ~/.bash_profile

    idem_install
}

pre_update() {
    info "pre update"
}

post_update() {
    info "post update"
    for pkg in `packages_from_github`
    do
        install_from_github $pkg
        update_from_github $pkg
    done
    idem_install
}

pre_remove() {
    warn "remove not supported - rebuild an image without it"
}
