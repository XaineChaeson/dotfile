# ===== Proxy aliases =====                                                                                                                                                                                            
alias proxyon='export http_proxy=http://192.168.5.110:20171 https_proxy=http://192.168.5.110:20171 all_proxy=socks5://192.168.5.110:20170'
alias proxyoff='unset http_proxy https_proxy all_proxy' 

# 可选：只对当前命令禁用代理
alias noproxy='env -u http_proxy -u https_proxy -u all_proxy'

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
