packages_from_github() {
    declare -a PACKAGES_FROM_GITHUB

    PACKAGES_FROM_GITHUB[0]="sstephenson/bats"           # tests in bash
    PACKAGES_FROM_GITHUB[1]="freakhill/scripts"          # my script
    PACKAGES_FROM_GITHUB[2]="fidian/ansi"                # colors and window title
    PACKAGES_FROM_GITHUB[4]="junegunn/fzf"               # fuzzy file finder
    PACKAGES_FROM_GITHUB[5]="paoloantinori/hhighlighter" # highlights
    PACKAGES_FROM_GITHUB[7]="tests-always-included/mo"   # moustache templates in bash

    echo ${PACKAGES_FROM_GITHUB[@]}
}

idem_install() {
    info "installing pearl packages"
    try pearl install liquidprompt ls-colors
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
        try stow -d "$dir/.." -t $HOME/.local $(echo "$1" | cut -f2 -d'/')
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
    try stow -d "$dir/.." -t $HOME/.local -R $(echo "$1" | cut -f2 -d'/')
    popd
    idem_install
}

post_install() {
    mkdir -p $HOME/.local/{bin,etc,run,lib,share,var/log}
    mkdir -p $HOME/.go

    for pkg in `packages_from_github`
    do
        install_from_github $pkg
    done

    info "running fzf install script"
    ( $PEARL_PKGVARDIR/junegunn/fzf/install --key-bindings --completion --no-update-rc)

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
    ln -s "$PEARL_PKGDIR/tmux.conf" $HOME/.tmux.conf
    info "link git config"
    rm -f $HOME/.gitconfig
    ln -s "$PEARL_PKGDIR/gitconfig" $HOME/.gitconfig
    info "link lein profile"
    mkdir -p $HOME/.lein
    rm -f $HOME/.lein/profiles.clj
    ln -s "$PEARL_PKGDIR/profiles.clj" $HOME/.lein/profiles.clj

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
}

pre_remove() {
    warn "remove not supported - rebuild an image without it"
}
