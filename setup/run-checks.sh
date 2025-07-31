source environment-check.sh
# Examples:
if ! check_version "nvim" 0 12 "nvim --version" "v"; then
  echo "install nvim"
fi
if ! check_version "tmux" 1 9 "tmux -V" "tmux"; then
  echo "install tmux"
fi
if ! check_version "batcat" 0 23 "batcat --version" "bat"; then
  echo "install bat/cat"
fi
if ! check_version "fzf" 0 27 "fzf --version" ""; then
  echo "install fzf"
fi
if ! check_version "fzf-tmux" 0 20 "fzf-tmux --version" "with fzf "; then
  echo "install fzf-tmux"
fi
