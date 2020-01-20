#!/bin/sh 

mkdir -p $HOME/bin
ln -sf $(pwd)/vm $HOME/bin/vm
cd vmip; make; cd - 

