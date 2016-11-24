export GOPATH=$HOME/go

eval "$(basher init -)"
eval "$(thefuck --alias)"
eval "$(fasd --init auto)"

[[ $- = *i* ]] && source $HOME/.basher/cellar/packages/nojhan/liquidprompt/liquidprompt
[[ $- = *i* ]] && source $HOME/.basher/cellar/packages/freakhill/scripts/lib/ssh_completion
[[ $- = *i* ]] && source $HOME/.basher/cellar/packages/freakhill/scripts/lib/git_completion
[[ $- = *i* ]] && source $HOME/.basher/cellar/packages/erichs/composure/composure.sh
[[ $- = *i* ]] && source $HOME/.basher/cellar/packages/paoloantinori/hhighlighter/h.sh
[[ $- = *i* ]] && source $HOME/.basher/cellar/packages/shyiko/commacd/commacd.bash
[[ $- = *i* ]] && source $HOME/.basher/cellar/packages/tests-always-included/mo/mo
[[ $- = *i* ]] && source $HOME/.basher/cellar/packages/jimeh/stub.sh/stub.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/Dropbox/bash_history ] && ln -sf ~/Dropbox/bash_history ~/.bash_history

## hh configuration after fzf to overwrite the C-R binding
# add this configuration to ~/.bashrc
export HH_CONFIG=hicolor         # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r
[[ $- = *i* ]] && bind '"\C-r": "\C-a hh \C-j"'

alias ll='ls -lG'

export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.guix-profile/bin:$HOME/.basher/bin:$GOPATH/bin
