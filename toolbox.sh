#!/bin/bash

echo " ____ ___ __  __  ___  _   _           __  __ ____  ____   ___  ____  "
echo "/ ___|_ _|  \/  |/ _ \| \ | |         |  \/  / ___||  _ \ / _ \/ ___| "
echo "\___ \| || |\/| | | | |  \| |  _____  | |\/| \___ \| | | | | | \___ \ "
echo " ___) | || |  | | |_| | |\  | |_____| | |  | |___) | |_| | |_| |___) |"
echo "|____/___|_|  |_|\___/|_| \_|         |_|  |_|____/|____/ \___/|____/  "

echo ""
echo "-------------------------------------------------"
echo "Welcome to the Sys Admin Tool Installer"
echo ""
echo "Are you installing on a Server or a Desktop?"
echo "1) Server"
echo "2) Desktop"
echo "-------------------------------------------------"

read -p "Enter your choice (1 or 2): " system_type

if [[ "$system_type" == "1" ]]; then
  echo "Server installation selected."
  tools=("htop" "nmap" "fail2ban" "docker.io" "git" "ufw" "vim" "apache2" "mysql-server" "tmux" "wget" "curl" "net-tools" "tree" "zip" "unzip" "jq" "rsync" "tcpdump" "traceroute" "chrony" "netcat")
elif [[ "$system_type" == "2" ]]; then
  echo "Desktop installation selected."
  tools=("htop" "git" "vim" "wget" "curl" "net-tools" "tree" "zip" "unzip" "jq" "rsync" "speedtest-cli" "neofetch" "zsh" "exa" "bat")
else
  echo "Invalid choice. Exiting."
  exit 1
fi

echo "Please select the numbers of the tools you want to install (comma-separated, e.g., 1,4,6):"
index=1
for tool in "${tools[@]}"; do
  echo "$index) $tool"
  index=$((index + 1))
done
echo "$index) Install All"
echo "$((index + 1))) Exit"
echo "-------------------------------------------------"
install_tool() {
  tool_name=$1
  echo "Installing $tool_name..."
  if command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y $tool_name
  elif command -v yum &> /dev/null; then
    sudo yum install -y $tool_name
  elif command -v dnf &> /dev/null; then
    sudo dnf install -y $tool_name
  else
    echo "Unsupported package manager, please install $tool_name manually."
  fi
}

install_all() {
  for tool in "${tools[@]}"; do
    install_tool $tool
  done
}
read -p "Enter your choices: " choice

if [[ "$choice" == "$index" ]]; then
  install_all
elif [[ "$choice" == "$((index + 1))" ]]; then
  echo "Exiting the script."
  exit 0
else
  IFS=',' read -ra selections <<< "$choice"
  for num in "${selections[@]}"; do
    if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#tools[@]} )); then
      install_tool "${tools[$((num-1))]}"
    else
      echo "Invalid selection: $num"
    fi
  done
fi