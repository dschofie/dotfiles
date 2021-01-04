# FZF stuff taken from https://github.com/junegunn/fzf/wiki/examples
# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
    local branches branch
    branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(authordate)%09%(objectname:short)%09%(refname:short)") &&
    branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    toCheckout=$(echo "$branch" | awk '{print $(NF)}') &&
    git checkout $(echo "$toCheckout" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Find branch, delete.
fbrd() {
    local branches branch
    branches=$(git branch --merged) &&
    branch=$(echo "$branches" | fzf +m) &&
    git branch -d $(echo "$branch" | sed "s/.* //") && fbrd
}

# fkill - kill process
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# # `tm` will allow you to select your tmux session via fzf.
# # `tm irc` will attach to the irc session (if it exists), else it will create it.

tm() {
    [[ -n "$TMUX"  ]] && change="switch-client" || change="attach-session"
    if [ $1 ]; then
        tmux $change -t "(" 2>/dev/null || (tmux new-session -d -s ( && tmux $change -t "("); return
    fi
    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

