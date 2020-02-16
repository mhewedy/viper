#!/bin/sh

mkdir -p "$HOME"/bin
ln -sf "$(pwd)"/vm "$HOME"/bin/vm
cd vmip; make; cd -

printf "\n# vm autocompletion script \nif [ -f '$(pwd)/zsh-autocompletion.sh' ]; then . '$(pwd)/zsh-autocompletion.sh'; fi\n\n" >> "$HOME"/.zshrc > /dev/null

if [ -f "$HOME"/.zshrc ]; then
    printf "export PATH=\$PATH:\$HOME/bin\n" >> "$HOME"/.zshrc
fi

if [ -f "$HOME"/.bashrc ]; then
  printf "export PATH=\$PATH:\$HOME/bin\n" >> "$HOME"/.bashrc
fi
