# Open aws console.
console() {
    if [[ $IS_DEVBOX  ]]; then
        agent-curl --unix-socket $HOME/co/backend/.devboxagent.sock http://localhost/awsokta --request POST -d $1
    else
        $HOME/co/backend/bin/aws-okta login okta-$1
    fi
}

lastcommit() {
	git log --format=%B -n 1 | tee >(pbcopy)
}

branchcommits() {
	local baseBranch
	baseBranch=$(git branch -l master main | xargs)
	git log --format=%B HEAD...$(git merge-base $baseBranch HEAD) | tee >(pbcopy)
}

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

last_log() {
    less $(bazel info output_base)
}

last_dir() {
    bazel info output_base
}

# Bazel test helper. Should auto-complete.
bt() {
}

dirls() {
    dirname % | xargs ls
}

bazeldirmarker() {
    if [[ -z "$1" ]]; then
	echo "set a path pls"
    fi

    mkdir -p $1/bazeldirmarker
    touch $1/bazeldirmarker/marker
    echo "exports_files([\"marker\"])" > $1/bazeldirmarker/BUILD.bazel
	git add -f $1/bazeldirmarker/BUILD.bazel
}

currentb() {
    git rev-parse --abbrev-ref HEAD | tee >(pbcopy)
}

newdata() {
    if [[ -z "$1" || -z "$2" ]]; then
		echo "set a path pls"
    fi

    tagetPath=$2
    if [[ "$targetPath" == "/home/ubuntu" ]]; then
		targetPath=$(echo "$targetPath"cut -d'{{/}}' -f{{4:}})
		targetPath="//$targetPath"
    fi
	
    echo "set add $1|$targetPath" >> buildozercmds
}

code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}


assume-role() {
	OUT=$(aws sts assume-role --role-arn $1 --role-session-name $2);\
	export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r '.Credentials''.AccessKeyId');\
	export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r '.Credentials''.SecretAccessKey');\
	export AWS_SESSION_TOKEN=$(echo $OUT | jq -r '.Credentials''.SessionToken');
}

assume-role-local() {
	OUT=$(awslocal sts assume-role --role-arn $1 --role-session-name $2);\
	export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r '.Credentials''.AccessKeyId');\
	export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r '.Credentials''.SecretAccessKey');\
	export AWS_SESSION_TOKEN=$(echo $OUT | jq -r '.Credentials''.SessionToken');
}
