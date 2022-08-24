#!/bin/bash

# Entrypoint to clone and checkout current files on machine.
# curl https://gist.githubusercontent.com/dschofie/bf8bec81444f2c019fd72f12f9a1a2a5/raw/7d41cc9bfc2eeb8b8f53351323e5b9996b0a7ba3/setup-dotfiles | /bin/bash
set -ex

if [[ ! -d ~/.oh-my-zsh ]]; then
	git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
	chsh -s $(which zsh)
fi

if [[ ! -d ~/diff-so-fancy ]]; then
	git clone git@github.com:so-fancy/diff-so-fancy.git ~/diff-so-fancy
fi

if [[ ! -d ~/powerlevel10k ]]; then
	git clone git@github.com:romkatv/powerlevel10k.git ~/powerlevel10k
fi

if [[ ! -d ~/.fzf ]]; then
	git clone https://github.com/junegunn/fzf.git ~/.fzf
	# Installs nice fuzzy finder completions.
	~/.fzf/install
fi

if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Use .vimrc for neovim https://neovim.io/doc/user/nvim.html#nvim-from-vim
if [[ ! -d "$HOME/.config/nvim" ]]; then
	mkdir -p "$HOME/.config/nvim"
fi

if [[ ! -f "$HOME/.config/nvim/init.vim" ]]; then
	tee "$HOME/.config/nvim/init.vim" <<EOF
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
EOF
fi

if [[ ! -d "$HOME/.vim/bundle/vim-easymotion" ]]; then
	mkdir -p "~/.vim/bundle"
	git clone https://github.com/easymotion/vim-easymotion ~/.vim/bundle/vim-easymotion
fi

case $(uname -s) in
Darwin)
	brew bundle -v --file=- <<-EOF
		brew "awscli"
		brew "bat"
		brew "direnv"
		brew "fd"
		brew "jq"
		brew "mosh"
		brew "neovim"
		brew "ripgrep"
		brew "tmux"
		brew "fasd"
		brew "tldr"
	EOF
	;;
Linux)
	sudo apt-get install -y \
		awscli \
		direnv \
		jq \
		mosh \
		neovim \
		ripgrep \
		tmux \
		fasd \
		tldr
	;;
esac
