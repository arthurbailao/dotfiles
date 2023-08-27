#!/bin/sh

#
# Utils
#
execute() {
	$1 &> /dev/null
	print_result $? "${2:-$1}"
}

print_error() {
	# red
	printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_info() {
	# blue
	printf "\n\e[0;34m $1\e[0m\n"
}

print_warning() {
	# light yellow
	printf "\e[0;93m  [!] $1 \e[0m\n"
}

print_question() {
	# yellow
	printf "\e[0;33m  [?] $1 \e[0m"
}

print_result() {
	[ $1 -eq 0 ] \
		&& print_success "$2" \
		|| print_error "$2"

	[ "$3" == "true" ] && [ $1 -ne 0 ] \
		&& exit
}

print_success() {
	# green
	printf "\e[0;32m  [✔] $1\e[0m\n"
}

symlink() {
	local sourceFile="$DOTFILES/$1"
	local targetFile="$HOME/$2"

	print_info "Linking $targetFile -> $sourceFile"

	if [ ! -e "$targetFile" ]; then
		execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
	elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
		print_success "$targetFile -> $sourceFile"
	else
		print_question "'$targetFile' already exists, do you want to overwrite it? [Y/n]"
		read yn
		case $yn in
			[Nn]* ) print_error "$targetFile → $sourceFile";;
			* )
				rm -rf "$targetFile"
				execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
				;;
		esac
	fi
}

#
# Install symlinks to dotfiles
#
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES

symlink "nvim" ".config/nvim"
