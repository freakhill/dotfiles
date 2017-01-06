declare -a PACKAGES_FROM_GITHUB

PACKAGES_FROM_GITHUB[0]="sstephenson/bats"           # tests in bash
PACKAGES_FROM_GITHUB[1]="jimeh/stub.sh"              # stub bash
PACKAGES_FROM_GITHUB[2]="freakhill/scripts"          # my script
PACKAGES_FROM_GITHUB[3]="fidian/ansi"                # colors and window title
PACKAGES_FROM_GITHUB[4]="clvv/fasd"                  # File Any Search Dir
PACKAGES_FROM_GITHUB[5]="junegunn/fzf"               # fuzzy file finder
PACKAGES_FROM_GITHUB[6]="paoloantinori/hhighlighter" # highlights
PACKAGES_FROM_GITHUB[7]="shyiko/commacd"             # ,(forward) ,,(back) ,,,(both)
PACKAGES_FROM_GITHUB[8]="tests-always-included/mo"   # moustache templates in bash

idem_install() {
    echo "idempotent install"
    ############################################################################
    ## PEARL installs
    try pearl install liquidprompt ls-colors
    ############################################################################
    ## CARGO installs
    cargo install racer parallel ripgrep
    ############################################################################
    ## GUIX installs
    guix package -i go ruby
    ### guix node package is broken so we install with stow
    #guix package -i node
    if ! type -a npm
    then
        mkdir -p $HOME/.stow
        pushd $PEARL_PKGVARDIR
        wget https://nodejs.org/dist/v6.9.3/node-v6.9.3-linux-x64.tar.xz
        tar xf node-v6.9.3-linux-x64.tar.xz
        rm node-v6.9.3-linux-x64.tar.xz
        stow -d $PEARL_PKGVARDIR -t $HOME/.local node-v6.9.3-linux-x64
        popd
    fi
    ############################################################################
    ## NPM installs
    npm install -g tldr
    stow -d $PEARL_PKGVARDIR -t $HOME/.local node-v6.9.3-linux-x64
    ############################################################################
    ## Hand installs
    pushd $HOME/.local/bin
    if ! type -a rq
    then
        curl -fsSLo rq https://s3-eu-west-1.amazonaws.com/record-query/record-query/x86_64-unknown-linux-musl/rq
        chmod +x rq
    fi
    popd
}

install_from_github() {
    local dir="$PEARL_PKGVARDIR/$1"
    mkdir -p "$dir/.."
    pushd "$dir/.."
    git clone https://github.com/$1
    stow -d "$dir/.." -t $HOME/.local $(echo "$1" | cut -f2 -d'/')
    popd
}

update_from_github() {
    local dir="$PEARL_PKGVARDIR/$1"
    pushd "$dir"
    git pull
    stow -d "$dir/.." -t $HOME/.local $(echo "$1" | cut -f2 -d'/')
    popd
}

post_install() {
    mkdir -p $HOME/.local/{bin,etc,run,lib,share,var}
    mkdir -p $HOME/.local/var/log
    mkdir -p $HOME/.go

    for pkg in ${PACKAGES_FROM_GITHUB[@]}
    do
        install_from_github $pkg
    done

    echo "running fzf install script"
    ( $PEARL_PKGVARDIR/junegunn/fzf/install )

    echo "make sur that our homemade ssh/scp scripts run fine"
    mkdir -p $HOME/.ssh/config.0
    mkdir -p $HOME/.ssh/backups
    touch $HOME/.ssh/config.0/empty
    touch $HOME/.ssh/settings
    touch $HOME/.ssh/config
    chmod 600 $HOME/.ssh/config

    [ "$(ls -A $HOME/.ssh/config.0)" ] && echo "config.0 not empty" \
            || cp $HOME/.ssh/config $HOME/.ssh/config.0/oldconfig

    echo "link tmux and git config"
    rm -f $HOME/.tmux.conf
    rm -f $HOME/.gitconfig
    ln -s "$PEARL_PKGDIR/tmux.conf" $HOME/.tmux.conf
    ln -s "$PEARL_PKGDIR/gitconfig" $HOME/.gitconfig

    echo "adding bashrc source to bash_profile for ssh"
    printf "\n[ -f ~/.bashrc ] && source ~/.bashrc\n" >> ~/.bash_profile

    echo "install lein"
    pushd ~/.local/bin
    curl -fsSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > lein
    chmod +x lein
    ./lein
    idem_install
}

pre_update() {
    echo "pre update"
}

post_update() {
    echo "post update"
    for pkg in ${PACKAGES_FROM_GITHUB[@]}
    do
        install_from_github $pkg
        update_from_github $pkg
    done
    idem_install
}

pre_remove() {
    echo "remove not supported - rebuild an image without it"
}
