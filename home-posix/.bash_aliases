##### ls 系列 #####
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

##### git 高频 #####
alias gs='git status'
alias gl='git log --oneline --graph --decorate'

##### tmux 高频 #####
alias t='tmux'
alias tls='tmux ls'
alias ta='tmux attach'
alias tat='tmux attach -t'

##### 目录跳转 #####
alias ..='cd ..'
alias ...='cd ../..'

##### 安全 & 效率 #####
alias rm='rm -i'
alias c='clear'
alias h='history | tail'

alias vsrc='vim +"source ~/.vimrc"'

# Local machine aliases, proxy settings, and private paths.
if [ -f "$HOME/.bash_aliases.local" ]; then
  . "$HOME/.bash_aliases.local"
fi
