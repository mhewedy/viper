#!/bin/sh

mkdir -p "$HOME"/bin
ln -sf "$(pwd)"/vm "$HOME"/bin/vm
cd vmip; make; cd -

printf "\n# vm autocompletion script \nif [ -f '$(pwd)/zsh-autocompletion.sh' ]; then . '$(pwd)/zsh-autocompletion.sh'; fi\n\n" >> "$HOME"/.zshrc
