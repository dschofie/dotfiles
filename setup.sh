#!/bin/bash
set -ex

if [[ ! -d ~/.oh-my-zsh ]]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    chsh -s $(which zsh)
fi

if [[ ! -d ~/diff-so-fancy ]]; then
    git clone git@github.com:so-fancy/diff-so-fancy.git ~/diff-so-fancy
fi

if [[ ! -d ~/.fzf ]]; then
    git clone https://github.com/junegunn/fzf.git ~/.fzf
    # Installs nice fuzzy finder completions.
    ~/.fzf/install
fi

if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

case $(uname -s) in
    Darwin)
        brew bundle -v --file=- <<-EOF
			brew "direnv"
			brew "fd"
			brew "jq"
			brew "tmux"
			brew "ripgrep"
EOF
esac


