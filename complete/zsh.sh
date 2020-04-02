#!/bin/sh

# TODO allow multiple input vms for start, stop and rm

stoppedVms() {
  diff <(vm ls) <(vm ps) | grep '<' | cut -d " " -f2
}

_vm() {
  local state
  _arguments '1: :(ls ps create rm start stop ssh port cp images ip)' '*: :->vms'

  case $state in
  vms)
    case $words[2] in
    create) _files ;;
    start) _describe 'command' "($(stoppedVms))" ;;
    rm) _describe 'command' "($(vm ls))" ;;
    ssh | stop | port | cp | ip) _describe 'command' "($(vm ps))" ;;
    esac
    ;;
  esac
}

compdef _vm vm
