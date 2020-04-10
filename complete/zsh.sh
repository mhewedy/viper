#!/bin/sh

# TODO allow multiple input vms for start, stop and rm

stoppedVms() {
  diff <(vboxmanage list vms | cut -d " " -f1 | cut -d "\"" -f2) <(vboxmanage list runningvms | cut -d " " -f1 | cut -d "\"" -f2) | grep '<' | cut -d " " -f2
}

_vm() {
  local state
  _arguments '1: :(ls ps create tag rm start stop ssh port cp images ip)' '*: :->vms'

  case $state in
  vms)
    case $words[2] in
    create) _files ;;
    start) _describe 'command' "($(stoppedVms))" ;;
    rm | tag) _describe 'command' "($(vboxmanage list vms | cut -d " " -f1 | cut -d "\"" -f2))" ;;
    ssh | stop | port | cp | ip) _describe 'command' "($(vboxmanage list runningvms | cut -d " " -f1 | cut -d "\"" -f2))" ;;
    esac
    ;;
  esac
}

compdef _vm viper
