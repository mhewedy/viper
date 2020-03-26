#!/bin/sh

# copy binaries
mkdir -p $HOME/bin
cp vm $HOME/bin
cp vmip $HOME/bin

# copy ssh key
mkdir -p $HOME/.ssh
cp -rf keys/vm_rsa $HOME/.ssh
chmod 600 $HOME/.ssh/vm_rsa

# modify shell rc files
if [ -f $HOME/.zshrc ] && [ ! -f $HOME/.vms/srcd ]; then
  printf "\n# vm autocompletion script
if [ -f '%s/zsh-autocompletion.sh' ];then
  . '%s/zsh-autocompletion.sh';
fi\n" "$(pwd)" "$(pwd)" >>$HOME/.zshrc

  printf "\n# add vm scripts to path \nexport PATH=\$PATH:\$HOME/bin\n\n" >>$HOME/.zshrc
fi

if [ -f $HOME/.bashrc ] && [ ! -f $HOME/.vms/srcd ]; then
  printf "\n# add vm scripts to path \nexport PATH=\$PATH:\$HOME/bin\n\n" >>$HOME/.bashrc
fi

mkdir -p $HOME/.vms/
touch $HOME/.vms/srcd

