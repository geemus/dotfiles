export EDITOR='vim'
export GIT_EDITOR='vim'

source ~/.git-completion

function parse_git_dirty {
 [ -d .git ] || return 1
 [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo " ☠"
}
function parse_git_branch {
 git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1]$(parse_git_dirty)/"
}
export PS1='\h \W$(parse_git_branch) ⌘ '

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
