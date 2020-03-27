#!/bin/sh

# copy binaries
mkdir -p $HOME/bin
mkdir -p $HOME/.vms

cp vm $HOME/bin
cp vmip $HOME/bin
cp imagelist $HOME/bin
cp complete/zsh.sh $HOME/.vms/complete-zsh.sh

# copy ssh key
mkdir -p $HOME/.ssh
cp -rf keys/vm_rsa $HOME/.ssh
chmod 600 $HOME/.ssh/vm_rsa

# prepare boxes
mkdir -p $HOME/.vms/boxes/

# modify shell rc files
if [ -f $HOME/.zshrc ] && [ ! -f $HOME/.vms/srcd ]; then
  printf "\n# vm autocompletion script
if [ -f '%s/.vms/complete-zsh.sh' ];then
  . '%s/.vms/complete-zsh.sh';
fi\n" "$HOME" "$HOME" >>$HOME/.zshrc

  printf "\n# add vm scripts to path \nexport PATH=\$PATH:\$HOME/bin\n\n" >>$HOME/.zshrc
fi

if [ -f $HOME/.bashrc ] && [ ! -f $HOME/.vms/srcd ]; then
  printf "\n# add vm scripts to path \nexport PATH=\$PATH:\$HOME/bin\n\n" >>$HOME/.bashrc
fi

mkdir -p $HOME/.vms/
touch $HOME/.vms/srcd
