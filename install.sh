#!/bin/sh

# copy binaries
mkdir -p $HOME/bin
mkdir -p $HOME/.viper

cp viper $HOME/bin
cp vmip $HOME/bin
cp vmports $HOME/bin
cp vmimages $HOME/bin
cp vminfo $HOME/bin

cp complete/zsh.sh $HOME/.viper/complete-zsh.sh

# copy ssh key
mkdir -p $HOME/.ssh
cp -rf keys/viper_rsa $HOME/.viper
chmod 600 $HOME/.viper/viper_rsa

# prepare boxes
mkdir -p $HOME/.viper/boxes/

# modify shell rc files
if [ -f $HOME/.zshrc ] && [ ! -f $HOME/.viper/srcd ]; then
  printf "\n# viper autocompletion script
if [ -f '%s/.viper/complete-zsh.sh' ];then
  . '%s/.viper/complete-zsh.sh';
fi\n" "$HOME" "$HOME" >>$HOME/.zshrc

  printf "\n# add viper scripts to path \nexport PATH=\$PATH:\$HOME/bin\n\n" >>$HOME/.zshrc
fi

if [ -f $HOME/.bashrc ] && [ ! -f $HOME/.viper/srcd ]; then
  printf "\n# add viper scripts to path \nexport PATH=\$PATH:\$HOME/bin\n\n" >>$HOME/.bashrc
fi

mkdir -p $HOME/.viper/
touch $HOME/.viper/srcd
