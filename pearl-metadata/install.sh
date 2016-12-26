post_install() {
cat <<EOF | bash -s
        echo "installing basher, because basher links bins and mans etc. nicely"
        git clone https://github.com/basherpm/basher.git ~/.basher
        export PATH="$HOME/.basher/bin:$PATH"
        eval "$(basher init -)"
        basher update # in a subshell to capture some kind of latent exit

        echo "installing usual packages"
        basher install sstephenson/bats           # tests in bash
        basher install jimeh/stub.sh              # stub bash
        basher install freakhill/scripts          # my script
        basher install fidian/ansi                # colors and window title
        basher install clvv/fasd                  # File Any Search Dir
        basher install junegunn/fzf               # fuzzy file finder
        basher install paoloantinori/hhighlighter # highlights
        basher install shyiko/commacd             # ,(forward) ,,(back) ,,,(both)
        basher install tests-always-included/mo   # moustache templates in bash

        echo "running fzf install script"
        ( $HOME/.basher/cellar/packages/junegunn/fzf/install )

        echo "make sur that our homemade ssh/scp scripts run fine"
        mkdir -p $HOME/.ssh/config.0
        mkdir -p $HOME/.ssh/backups
        touch $HOME/.ssh/config.0/empty
        touch $HOME/.ssh/settings
        touch $HOME/.ssh/config
        chmod 600 $HOME/.ssh/config

        [ "$(ls -A $HOME/.ssh/config.0)" ] && echo "config.0 not empty" \
                || cp $HOME/.ssh/config $HOME/.ssh/config.0/oldconfig

        echo "create the golang go folder"
        mkdir -p $HOME/go

        echo "link tmux and git config"
        rm -f $HOME/.tmux.conf
        rm -f $HOME/.gitconfig
        ln -s "$PEARL_PKGDIR/tmux.conf" $HOME/.tmux.conf
        ln -s "$PEARL_PKGDIR/gitconfig" $HOME/.gitconfig

        echo "adding bashrc source to bash_profile for ssh"
        cat <<EOF2 > ~/.bash_profile
[ -f ~/.bashrc ] && source ~/.bashrc
EOF2

        echo "install lein"
        pushd ~/.local/bin
        curl -fsSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > lein
        chmod +x lein
        ./lein
EOF
}

pre_update() {
    echo "NYI"
}

post_update() {
    cat <<EOF | bash -s
        echo "NYI"
        basher update
        for p in `basher outdated`
        do
            basher upgrade $p
        done
EOF
}

pre_remove() {
    unlink tmux "$PEARL_PKGDIR/tmux.conf"
    unlink git  "$PEARL_PKGDIR/gitconfig"
    echo "removing basher"
    rm -fr ~/.basher
}

post_remove() {
    echo "NYI"
}
