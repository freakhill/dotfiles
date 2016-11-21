post_install() {
    info "installing basher, because basher links bins and mans etc. nicely"
    git clone https://github.com/basherpm/basher.git ~/.basher
    export PATH="$HOME/.basher/bin:$PATH"
    eval "$(basher init -)"
    basher update

    info "installing usual packages"
    basher install sstephenson/bats           # tests in bash
    basher install jimeh/stub.sh              # stub bash
    basher install freakhill/scripts          # my script
    basher install fidian/ansi                # colors and window title
    basher install clvv/fasd                  # File Any Search Dir
    basher install junegunn/fzf               # fuzzy file finder
    basher install paoloantinori/hhighlighter # highlights
    basher install shyiko/commacd             # ,(forward) ,,(back) ,,,(both)
    basher install tests-always-included/mo   # moustache templates in bash

    info "running fzf install script"
    $HOME/.basher/cellar/packages/junegunn/fzf/install

    info "make sur that our homemade ssh/scp scripts run fine"
    chmod 700 $HOME/.ssh
    mkdir -p $HOME/.ssh/config.0
    chmod 700 $HOME/.ssh/config.0
    touch $HOME/.ssh/config
    chmod 600 $HOME/.ssh/config

    info "create the golang go folder"
    mkdir -p $HOME/go

    info "link tmux and git config"
    link tmux "$PEARL_PKGDIR/tmux.conf"
    link git  "$PEARL_PKGDIR/gitconfig"
}

pre_update() {
    echo "nothing yet in pre-update..."
}

post_update() {
    info "updating basher stuff"
    basher update
    for p in `basher outdated`
    do
        basher upgrade $p
    done
}

pre_remove() {
    unlink tmux "$PEARL_PKGDIR/tmux.conf"
    unlink git  "$PEARL_PKGDIR/gitconfig"
    info "removing basher"
    rm -fr ~/.basher
}

post_remove() {
    echo "nothing yet in post-remove..."
}
