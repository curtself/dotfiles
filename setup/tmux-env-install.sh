#!/bin/bash

# testing path, will use ~ (/home/cself) for real install
LHOME=/home/cself/projects/dotfiles/home

# install/clone TPM, but make sure it is not present first
if [ -d $LHOME/.tmux/plugins/tpm ]; then
  echo "TPM already installed"
else
  git clone https://github.com/tmux-plugins/tpm $LHOME/.tmux/plugins/tpm
fi

# check config directory and create if if needed
if [ -d $LHOME/.config/tmux ]; then
  echo "tmux config directory exists"
else
  echo "tmux conig directory DOES NOT exist, creating..."
  mkdir -p "$LHOME/.config/tmux"
fi
