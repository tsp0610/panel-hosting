#!/bin/bash

# Installer Script for Draco and Skyport Panels
# Author: [Your Name or GitHub Handle]

# Colors for output
RED='\033[0;31m'      # Errors and warnings/disclaimers
GREEN='\033[0;32m'    # Success messages and menu titles
CYAN='\033[0;36m'     # Menu options and general messages
YELLOW='\033[1;33m'   # Prompts and borders
BOLD='\033[1m'        # Bold text for emphasis
UNDERLINE='\033[4m'   # Underline for links
NC='\033[0m'          # No Color

# Function to display messages (now with color parameter)
function echo_message {
  local color="$1"
  shift
  echo -e "${color}$@${NC}"
}

# Function to simulate fade-in for menus (prints lines with delay)
function fade_in_menu {
  clear
  for line in "$@"; do
    echo -e "$line"  # Ensure -e is used for interpreting escape sequences
    sleep 0.1  # Short delay for fade-in effect
  done
}

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo_message "$RED" "Please run this script as root."
  exit 1
fi

# Typing Animation for Credits (quick typing in 1s total)
credit_text="${YELLOW}${BOLD}Credit by ${GREEN}${BOLD}Jishnu ${YELLOW}${BOLD}and ${CYAN}${BOLD}Joy !!!${NC}"
clear
echo -n ""  # Start on a new line
displayed=""
for (( i=0; i<${#credit_text}; i++ )); do
  displayed="${displayed}${credit_text:$i:1}"
  echo -ne "\r${displayed}"  # Overwrite the line with interpreted colors
  sleep 0.025  # Adjusted delay for ~1 second total typing
done
echo ""  # New line after typing
sleep 0.5  # Brief hold after typing
clear    # Clear screen before main menu

# Function for Main Menu
function main_menu {
  while true; do
    fade_in_menu \
      "" \
      "${YELLOW}============================${NC}" \
      "${GREEN}${BOLD}         Main Menu         ${NC}" \
      "${YELLOW}============================${NC}" \
      "${CYAN}1) Install Panel${NC}" \
      "${CYAN}2) 24/7 Run${NC}" \
      "${CYAN}3) Tunnel Create${NC}" \
      "${CYAN}4) Exit${NC}" \
      "${YELLOW}============================${NC}" \
      ""
    echo -ne "${YELLOW}Enter your choice [1-4]: ${NC}"
    read choice
    case $choice in
      1) panel_menu ;;
      2) run_24_7 ;;
      3) tunnel_create ;;
      4) echo_message "$GREEN" "Exiting..."; exit 0 ;;
      *) echo_message "$RED" "Invalid selection. Please try again." ;;
    esac
  done
}

# Function for Panel Selection Sub-Menu (updated with Puffer as 1, Draco as 2, Skyport as 3)
function panel_menu {
  while true; do
    fade_in_menu \
      "" \
      "${YELLOW}==============================${NC}" \
      "${GREEN}${BOLD}      Select Panel Type      ${NC}" \
      "${YELLOW}==============================${NC}" \
      "${CYAN}1) Puffer Panel${NC}" \
      "${CYAN}2) Draco${NC}" \
      "${CYAN}3) Skyport${NC}" \
      "${CYAN}4) Back${NC}" \
      "${YELLOW}==============================${NC}" \
      ""
    echo -ne "${YELLOW}Enter your choice [1-4]: ${NC}"
    read sub_choice
    case $sub_choice in
      1) clear; puffer_menu ;;
      2) clear; draco_menu ;;
      3) clear; skyport_menu ;;
      4) clear; return ;;  # Clear and back to main menu
      *) echo_message "$RED" "Invalid selection. Please try again." ;;
    esac
  done
}

# Function for Puffer Sub-Sub-Menu (simplified: only install and back)
function puffer_menu {
  while true; do
    fade_in_menu \
      "" \
      "${YELLOW}==================================${NC}" \
      "${GREEN}${BOLD}         Puffer Options         ${NC}" \
      "${YELLOW}==================================${NC}" \
      "${CYAN}1) Install Puffer Panel${NC}" \
      "${CYAN}2) Back${NC}" \
      "${YELLOW}==================================${NC}" \
      ""
    echo -ne "${YELLOW}Enter your choice [1-2]: ${NC}"
    read puffer_choice
    case $puffer_choice in
      1)
        echo_message "$GREEN" "Installing Puffer Panel..."
        bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Vps/refs/heads/main/puffer-panel)
        echo_message "$GREEN" "Puffer Panel installation completed!"
        prompt_daemon "puffer"
        ;;
      2) clear; return ;;  # Clear and back to panel menu
      *) echo_message "$RED" "Invalid selection. Please try again." ;;
    esac
  done
}

# Function for Draco Sub-Sub-Menu
function draco_menu {
  while true; do
    fade_in_menu \
      "" \
      "${YELLOW}==================================${NC}" \
      "${GREEN}${BOLD}          Draco Options          ${NC}" \
      "${YELLOW}==================================${NC}" \
      "${CYAN}1) Install Draco Panel${NC}" \
      "${CYAN}2) Install Draco Daemon (wings)${NC}" \
      "${CYAN}3) Start Panel${NC}" \
      "${CYAN}4) Start Daemon${NC}" \
      "${CYAN}5) Back${NC}" \
      "${YELLOW}==================================${NC}" \
      ""
    echo -ne "${YELLOW}Enter your choice [1-5]: ${NC}"
    read draco_choice
    case $draco_choice in
      1)
        echo_message "$GREEN" "Installing Draco Panel..."
        bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Vps/refs/heads/main/draco)
        echo_message "$GREEN" "Draco Panel installation completed!"
        prompt_daemon "draco"
        ;;
      2)
        echo_message "$GREEN" "Installing Draco Daemon (wings)..."
        bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Vps/refs/heads/main/daemon)
        echo_message "$GREEN" "Your daemon(wings) is complet install make sure paste the 1 & 2 is your node (daemon)configure code"
        echo -e "${CYAN}1) cd Vortex-Deamon${NC}"
        echo -e "${CYAN}2) paste your configure${NC}"
        echo -ne "${YELLOW}${BOLD}Do you want to go back? (yes/no): ${NC}"
        read go_back
        if [[ "$go_back" == "yes" ]]; then
          draco_menu
        else
          echo_message "$GREEN" "Exiting..."
          exit 0
        fi
        ;;
      3)
        echo_message "$GREEN" "Starting Panel..."
        cd panel && cd panel && node .
        echo_message "$GREEN" "Panel has been started!"
        ;;
      4)
        echo_message "$GREEN" "Starting Daemon..."
        cd daemon && cd daemon && node .
        echo_message "$GREEN" "Daemon has been started!"
        ;;
      5) clear; return ;;  # Clear and back to panel menu
      *) echo_message "$RED" "Invalid selection. Please try again." ;;
    esac
  done
}

# Function for Skyport Sub-Sub-Menu
function skyport_menu {
  while true; do
    fade_in_menu \
      "" \
      "${YELLOW}==================================${NC}" \
      "${GREEN}${BOLD}         Skyport Options         ${NC}" \
      "${YELLOW}==================================${NC}" \
      "${CYAN}1) Install Skyport Panel${NC}" \
      "${CYAN}2) Install Daemon (wings)${NC}" \
      "${CYAN}3) Start Panel${NC}" \
      "${CYAN}4) Start Daemon${NC}" \
      "${CYAN}5) Back${NC}" \
      "${YELLOW}==================================${NC}" \
      ""
    echo -ne "${YELLOW}Enter your choice [1-5]: ${NC}"
    read skyport_choice
    case $skyport_choice in
      1)
        echo_message "$GREEN" "Installing Skyport Panel..."
        bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Vps/refs/heads/main/skyport)
        echo_message "$GREEN" "Skyport Panel installation completed!"
        prompt_daemon "skyport"
        ;;
      2)
        echo_message "$GREEN" "Installing Daemon (wings)..."
        bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/skyport/refs/heads/main/wings)
        echo_message "$GREEN" "Your daemon(wings) is complet install make sure paste the 1 & 2 is your node (daemon)configure code"
        echo -e "${CYAN}1) cd skyportd${NC}"
        echo -e "${CYAN}2) paste your configure${NC}"
        echo -ne "${YELLOW}${BOLD}Do you want to go back? (yes/no): ${NC}"
        read go_back
        if [[ "$go_back" == "yes" ]]; then
          skyport_menu
        else
          echo_message "$GREEN" "Exiting..."
          exit 0
        fi
        ;;
      3)
        echo_message "$GREEN" "Starting Panel..."
        cd panel && node .
        echo_message "$GREEN" "Panel has been started!"
        ;;
      4)
        echo_message "$GREEN" "Starting Daemon..."
        cd skyportd && node .
        echo_message "$GREEN" "Daemon has been started!"
        ;;
      5) clear; return ;;  # Clear and back to panel menu
      *) echo_message "$RED" "Invalid selection. Please try again." ;;
    esac
  done
}

# Function to run the 24/7 service
function run_24_7 {
  echo_message "$GREEN" "Running 24/7 service..."
  python3 <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/24-7/refs/heads/main/24)
}

# Function for Tunnel Creation
function tunnel_create {
  fade_in_menu \
    "" \
    "${YELLOW}========================================${NC}" \
    "${GREEN}${BOLD}            Tunnel Create            ${NC}" \
    "${YELLOW}========================================${NC}" \
    "" \
    "${RED}${BOLD}          Important Disclaimer          ${NC}" \
    "${RED}${BOLD}To connect this server, you must sign in${NC}" \
    "${RED}${BOLD}or create an account at ${UNDERLINE}https://playit.gg/${NC}${RED}${BOLD}.${NC}" \
    "${RED}${BOLD}This is required for tunnel functionality.${NC}" \
    "" \
    "${YELLOW}========================================${NC}" \
    ""
  echo -ne "${YELLOW}${BOLD}Do you want to proceed? (yes/no): ${NC}"
  read proceed
  if [[ "$proceed" == "yes" || "$proceed" == "y" ]]; then
    while true; do
      fade_in_menu \
        "" \
        "${YELLOW}==================================${NC}" \
        "${GREEN}${BOLD}         Tunnel Options         ${NC}" \
        "${YELLOW}==================================${NC}" \
        "${CYAN}1) Create Tunnel${NC}" \
        "${CYAN}2) Start Tunnel${NC}" \
        "${CYAN}3) Back${NC}" \
        "${YELLOW}==================================${NC}" \
        ""
      echo -ne "${YELLOW}Enter your choice [1-3]: ${NC}"
      read tunnel_choice
      case $tunnel_choice in
        1)
          # Simulate popup with 5s delay
          clear
          echo -e "${YELLOW}=============================${NC}"
          echo -e "${RED}${BOLD} Wait for creating the link...${NC}"
          echo -e "${YELLOW}=============================${NC}"
          sleep 5
          clear
          echo_message "$GREEN" "Creating Tunnel..."
          wget https://github.com/playit-cloud/playit-agent/releases/download/v0.15.26/playit-linux-amd64
          chmod +x playit-linux-amd64
          ./playit-linux-amd64
          ;;
        2)
          echo_message "$GREEN" "Starting Tunnel..."
          ./playit-linux-amd64
          ;;
        3) clear; return ;;  # Clear and back to main menu
        *) echo_message "$RED" "Invalid selection. Please try again." ;;
      esac
    done
  else
    echo_message "$RED" "Tunnel creation canceled."
  fi
}

# Function to prompt for daemon installation after panel install
function prompt_daemon {
  local panel_type="$1"
  echo -ne "${YELLOW}${BOLD}Do you want to install the daemon (wings)? (yes/no): ${NC}"
  read install_daemon
  if [[ "$install_daemon" == "yes" || "$install_daemon" == "y" ]]; then
    echo_message "$GREEN" "Installing Daemon (wings)..."
    if [[ "$panel_type" == "skyport" ]]; then
      bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/skyport/refs/heads/main/wings)
    else
      bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Vps/refs/heads/main/daemon)
    fi
    echo_message "$GREEN" "Your daemon(wings) is complet install make sure paste the 1 & 2 is your node (daemon)configure code"
    if [[ "$panel_type" == "skyport" ]]; then
      echo -e "${CYAN}1) cd skyportd${NC}"
    else
      echo -e "${CYAN}1) cd Vortex-Deamon${NC}"
    fi
    echo -e "${CYAN}2) paste your configure${NC}"
    echo -ne "${YELLOW}${BOLD}Do you want to go back? (yes/no): ${NC}"
    read go_back
    if [[ "$go_back" == "yes" ]]; then
      if [[ "$panel_type" == "draco" ]]; then
        draco_menu
      elif [[ "$panel_type" == "skyport" ]]; then
        skyport_menu
      else
        panel_menu
      fi
    else
      echo_message "$GREEN" "Exiting..."
      exit 0
    fi
  else
    echo_message "$RED" "Daemon (wings) installation skipped."
  fi
}

# Start the script with the main menu
main_menu
