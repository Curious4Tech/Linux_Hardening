#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="/var/log/security_hardening.log"

# Function for logging
log() {
    echo "$(date): $1" | sudo tee -a $LOG_FILE
}


# Function to install figlet
install_figlet() {
    if [ -x "$(command -v apt)" ]; then
        echo "Installing figlet using apt..."
        sudo apt update
        sudo apt install -y figlet
    elif [ -x "$(command -v yum)" ]; then
        echo "Installing figlet using yum..."
        sudo yum install -y figlet
    else
        echo "Package manager not found. Please install figlet manually."
        exit 1
    fi
}

# Check if figlet is installed
if ! command -v figlet &> /dev/null; then
    echo "figlet is not installed. Installing now..."
    install_figlet
fi


# Display welcome message
figlet -f slant "Welcome to Linux Security"
echo ""
echo -e "${GREEN}==============================${NC}"
echo -e "${RED} LINUX SECURITY HARDENING SCRIPT ${NC}"
echo -e "${GREEN}==============================${NC}"

# Update and upgrade the system
log "Updating system..."
sudo apt-get update -y && sudo apt-get upgrade -y

# Install UFW and configure basic rules
log "Configuring UFW..."
sudo apt-get install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable

# Disable root login via SSH
log "Disabling root login via SSH..."
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Set up password policies
log "Setting password policies..."
sudo apt-get install libpam-pwquality -y
sudo sed -i '/^password.*pam_pwquality.so/c\password requisite pam_pwquality.so retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 difok=4 reject_username enforce_for_root' /etc/pam.d/common-password
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 10/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE 7/' /etc/login.defs

# Disable unused services (Example: CUPS)
log "Disabling unused services..."
sudo systemctl disable cups
sudo systemctl stop cups

# Set secure file permissions
log "Securing file permissions..."
sudo chmod 700 /home/*
sudo chown root:root /etc/passwd /etc/shadow /etc/group /etc/gshadow
sudo chmod 644 /etc/passwd /etc/group
sudo chmod 600 /etc/shadow /etc/gshadow

# Additional system hardening
log "Applying additional system hardening..."

# Disable USB storage
echo -e "${GREEN}*install usb-storage /bin/true ${NC}" | sudo tee -a /etc/modprobe.d/disable-usb-storage.conf

# Disable core dumps
echo -e "${GREEN}* hard core 0 ${NC}" | sudo tee -a /etc/security/limits.conf

# Disable IPv6 if not needed
echo -e "${GREEN} net.ipv6.conf.all.disable_ipv6 = 1 ${NC}" | sudo tee -a /etc/sysctl.conf
echo -e "${GREEN} net.ipv6.conf.default.disable_ipv6 = 1 ${NC}" | sudo tee -a /etc/sysctl.conf
echo -e "${GREEN} net.ipv6.conf.lo.disable_ipv6 = 1 ${NC}" | sudo tee -a /etc/sysctl.conf

# Apply sysctl changes
sudo sysctl -p

# Verify changes
log "Verifying configuration..."
sudo ufw status verbose
sudo systemctl status sshd

log "Basic Linux security hardening completed."

echo -e "${GREEN} Security hardening script completed. Please check $LOG_FILE for details !!! ${NC}"

figlet -f slant "Stay Secured !"
