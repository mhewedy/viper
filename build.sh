#!/bin/sh

mkdir -p "$HOME"/bin
ln -sf "$(pwd)"/vm "$HOME"/bin/vm
cd vmip; make; cd -

if [ -f "$HOME"/.zshrc ]; then
    printf "\n# vm autocompletion script \nif [ -f '$(pwd)/zsh-autocompletion.sh' ]; then . '$(pwd)/zsh-autocompletion.sh'; fi\n\n" >> "$HOME"/.zshrc
    printf "\n\nexport PATH=\$PATH:\$HOME/bin\n\n" >> "$HOME"/.zshrc
fi

if [ -f "$HOME"/.bashrc ]; then
  printf "\n\nexport PATH=\$PATH:\$HOME/bin\n\n" >> "$HOME"/.bashrc
fi
