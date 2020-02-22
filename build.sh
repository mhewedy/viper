#!/bin/sh

mkdir -p "$HOME"/bin
ln -sf "$(pwd)"/vm "$HOME"/bin/vm
cd vmip; make; cd -

if [ -f "$HOME"/.zshrc ]; then
  printf "\n# vm autocompletion script
  if [ -f '%s/zsh-autocompletion.sh' ];then
    . '%s/zsh-autocompletion.sh';
  fi\n" "$(pwd)" "$(pwd)" >>"$HOME"/.zshrc
  
  printf "\n# add vm scripts to path \nexport PATH=\$PATH:\$HOME/bin\n\n" >>"$HOME"/.zshrc
fi

if [ -f "$HOME"/.bashrc ]; then
  printf "\n# add vm scripts to path \nexport PATH=\$PATH:\$HOME/bin\n\n" >>"$HOME"/.bashrc
fi
