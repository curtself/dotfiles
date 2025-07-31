#!/usr/bin/env bash

check_version() {
    local tool_name="$1"
    local required_major="$2"
    local required_minor="$3"
    local version_command="$4"
    local strip_prefix="$5"

    if ! command -v "$tool_name" >/dev/null 2>&1; then
        echo "$tool_name not found"
        return 1
    fi

    local output
    output="$($version_command 2>/dev/null | head -n 1)"
    output="${output#*$strip_prefix}"  # Strip prefix if needed

    # Extract major/minor using '.' as separator (avoiding <<<)
    local version_raw
    version_raw=$(echo "$output" | grep -oE '[0-9]+\.[0-9]+')
    local major=$(echo "$version_raw" | cut -d. -f1)
    local minor=$(echo "$version_raw" | cut -d. -f2)

    if [ "$major" -gt "$required_major" ] || { [ "$major" -eq "$required_major" ] && [ "$minor" -ge "$required_minor" ]; }; then
        return 0
    else
        return 1
    fi
}

prompt_yes_no() {
    local prompt_msg="$1"
    local default_answer="${2:-n}"  # Default to "no" if not specified

    local answer
    read -rp "$prompt_msg [y/N] " answer
    case "${answer:-$default_answer}" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

# helper install scripts
install_fzf() {
    local homedir="$1"
    if prompt_yes_no "Do you want to install fzf from Git to $homedir/.fzf?"; then
      git clone --depth 1 https://github.com/junegunn/fzf.git $homedir/.fzf
      $homedir/.fzf/install
    else
      echo "fzf install skipped"
    fi
}

install_tmux() {
  local homedir="$1"
}

install_nvim() {
  local homedir="$1"
}

install_batcat_OLD() {
  local homedir="$1"
  wget https://github.com/sharkdp/bat/releases/download/v0.25.0/bat_0.25.0_amd64.deb -O /tmp/bat_amd64.deb
  sudo dpkg -i /tmp/bat_amd64.deb  
  mkdir -p $homedir/.local/bin
  ln -s /usr/bin/batcat $homedir/.local/bin/bat
}

install_batcat() {
  local homedir="$1"
  local api_url="https://api.github.com/repos/sharkdp/bat/releases/latest"
  local deb_url

  echo "Fetching latest bat release info with wget..."
  # Save API response to a temp file
  wget -qO- "$api_url" > /tmp/bat_latest_release.json

  # Extract the .deb URL for amd64
  #deb_url=$(grep "browser_download_url" /tmp/bat_latest_release.json | grep "amd64.deb" | sed -E 's/.*"([^"]+)".*/\1/')

  # Match only the .deb file that follows the pattern: bat_*.deb (not bat-musl, etc.)
  deb_url=$(grep "browser_download_url" /tmp/bat_latest_release.json \
    | grep -Eo 'https://[^"]+bat_[^"]+_amd64\.deb' \
    | head -n1)

  if [ -z "$deb_url" ]; then
    echo "❌ Failed to find .deb download URL for bat"
    return 1
  fi

  echo "Downloading bat from: $deb_url"
  wget "$deb_url" -O /tmp/bat_amd64.deb
  sudo dpkg -i /tmp/bat_amd64.deb

  mkdir -p "$homedir/.local/bin"
  ln -sf /usr/bin/batcat "$homedir/.local/bin/bat"
}


install_rg() {
  local homedir="$1"
  echo "installing ripgrep..."
}



