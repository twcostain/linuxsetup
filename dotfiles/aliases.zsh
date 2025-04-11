#Standard ls alias
alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'
alias lal='ll -a'

#rm Safety
alias rm='rm -i'

#chown Safety
alias chown='chown -h'

#Remove deleted remote branches from local git tree
alias cleangit="git fetch --prune && git branch -vv | grep gone | awk '{print \$1}' | xargs -t git branch -D"
