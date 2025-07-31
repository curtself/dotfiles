#!/usr/bin/env bash

# Source the version checker function
source helpers.sh

# Define required tools: name major minor command prefix
REQUIRED_TOOLS=(
  "nvim 0 11 nvim --version v"
  "tmux 1 9 tmux -V tmux"
  "bat 0 19 bat --version bat"
  "fzf 0 27 fzf --version ''"
  "fzf-tmux 0 20 fzf-tmux --version 'with fzf '"
  "rg 12 0 rg --version 'ripgrep '"
)

# Initialize result arrays
TO_INSTALL=()
TO_UPDATE=()

#homedir="$HOME"  # Or override for testing
homedir="/home/cself/projects/dotfiles/home"  # Or override for testing

# Helper to split tool lines safely without <<< or arrays
parse_tool_line() {
  local line="$1"
  TOOL=$(printf "%s" "$line" | cut -d' ' -f1)
  MAJOR=$(printf "%s" "$line" | cut -d' ' -f2)
  MINOR=$(printf "%s" "$line" | cut -d' ' -f3)
  CMD=$(printf "%s" "$line" | cut -d' ' -f4- | awk '{print $1" "$2}')
  PREFIX=$(printf "%s" "$line" | cut -d' ' -f6-)
}

# Process each tool
for line in "${REQUIRED_TOOLS[@]}"; do
  parse_tool_line "$line"

  if ! command -v "$TOOL" >/dev/null 2>&1; then
    TO_INSTALL+=("$TOOL")
  elif ! check_version "$TOOL" "$MAJOR" "$MINOR" "$CMD" "$PREFIX"; then
    TO_UPDATE+=("$TOOL")
  fi
done

# Report summary
if [ ${#TO_INSTALL[@]} -eq 0 ] && [ ${#TO_UPDATE[@]} -eq 0 ]; then
  echo "✅ All tools meet version requirements."
  exit 0
fi

echo
if [ ${#TO_INSTALL[@]} -gt 0 ]; then
  echo "🛠️  Need to install:"
  for t in "${TO_INSTALL[@]}"; do echo "  - $t"; done
fi

if [ ${#TO_UPDATE[@]} -gt 0 ]; then
  echo "🛠️  Need to update:"
  for t in "${TO_UPDATE[@]}"; do echo "  - $t"; done
fi

echo
printf "Proceed with all installs/updates? [y/N]: "
read -r all_answer

if echo "$all_answer" | grep -iq '^y'; then
  for tool in "${TO_INSTALL[@]}" "${TO_UPDATE[@]}"; do
    func="install_${tool//-/_}"
    if type "$func" >/dev/null 2>&1; then
      "$func" "$homedir"
    else
      echo "⚠️  No install function defined for $tool"
    fi
  done
else
  # Combine arrays to check total count
  ALL_ACTIONS=("${TO_INSTALL[@]}" "${TO_UPDATE[@]}")
  
  # Only prompt individually if there are multiple actions
  if [ "${#ALL_ACTIONS[@]}" -gt 1 ]; then
    for tool in "${ALL_ACTIONS[@]}"; do
      printf "Install or update %s? [y/N]: " "$tool"
      read -r answer
      if echo "$answer" | grep -iq '^y'; then
        func="install_${tool//-/_}"
        if type "$func" >/dev/null 2>&1; then
          "$func" "$homedir"
        else
          echo "⚠️  No install function defined for $tool"
        fi
      fi
    done
  fi
  
fi

# install/clone TPM, but make sure it is not present first
if [ -d $homedir/.tmux/plugins/tpm ]; then
  echo "TPM already installed"
else
  if prompt_yes_no "Missing tmux TPM, install? " ; then
    git clone https://github.com/tmux-plugins/tpm $homedir/.tmux/plugins/tpm
  fi
fi

