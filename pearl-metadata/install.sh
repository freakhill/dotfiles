post_install() {
    # install basher
    git clone https://github.com/basherpm/basher.git ~/.basher
    export PATH="$HOME/.basher/bin:$PATH"
    eval "$(basher init -)"
    basher update
    basher install sstephenson/bats           # tests in bash
    basher install jimeh/stub.sh              # stub bash
    basher install freakhill/scripts          # my script
    basher install fidian/ansi                # colors and window title
    basher install clvv/fasd                  # File Any Search Dir
    basher install junegunn/fzf               # fuzzy file finder
    basher install paoloantinori/hhighlighter # highlights
    basher install shyiko/commacd             # ,(forward) ,,(back) ,,,(both)
    basher install tests-always-included/mo   # moustache templates in bash
    # fzf requires a post basher install script
    $HOME/.basher/cellar/packages/junegunn/fzf/install
    # ensure that the ssh/scp scripts are usable
    mkdir -p $HOME/.ssh/config.0
    touch $HOME/.ssh/config
    chmod 700 $HOME/.ssh
    chmod 600 $HOME/config
    # golang folder
    mkdir -p $HOME/go

    link tmux "$PEARL_PKGDIR/tmux.conf"
    link git  "$PEARL_PKGDIR/gitconfig"
}

pre_update() {
    echo "nothing yet in pre-update..."
}

post_update() {
    basher update
    for p in `basher outdated`
    do
        basher upgrade $p
    done
}

pre_remove() {
    echo "nothing yet in uninstall..."
}

post_remove() {
    echo "nothing yet in post-remove..."
}
