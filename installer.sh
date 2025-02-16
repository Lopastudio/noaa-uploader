#!/bin/bash

# Check if we are running in sudo with the most complex way possible, SO I HAVE THE POWEEEEER TO INSTALL EVERYTHINGG :D
# basically using multiple methods of detecting sudo to support all shells, even ARCH
if [ "$EUID" -eq 0 ] 2>/dev/null || [ "$(id -u 2>/dev/null)" -eq 0 ] || [ "$(whoami 2>/dev/null)" = "root" ]; then
    echo "RASPBERRY-NOAA-V2 NOAA/Meteor image uploader installer-"
else
    echo "This script must be run as root!"
    exit 1
fi

# Get those colours working
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RED="\e[31m"
RESET="\e[0m"

# Dependency installing
install_dependencies() {
    echo -e "${YELLOW}Checking and installing required dependencies...${RESET}"
    if command -v apt-get >/dev/null; then
        sudo apt-get update && sudo apt-get install -y ftp curl
    elif command -v pacman >/dev/null; then
        sudo pacman -Syu --noconfirm ftp curl
    elif command -v yum >/dev/null; then
        sudo yum install -y ftp curl
    else
        echo -e "${RED}Unsupported package manager. Please install dependencies manually.${RESET}"
        exit 1
    fi
    echo -e "${GREEN}Dependencies installed successfully!${RESET}"
}

# Remove script + crontab
uninstall() {
    echo -e "${RED}Uninstalling FTP Uploader...${RESET}"
    rm -f "$SCRIPT_PATH"
    crontab -l | grep -v "$SCRIPT_PATH" | crontab -
    echo -e "${GREEN}Uninstallation complete.${RESET}"
    exit 0
}

# Name says it all...
test_ftp_credentials() {
    echo -e "${YELLOW}Testing FTP credentials...${RESET}"
    RESULT=$(echo -e "open $FTP_SERVER\nuser $FTP_USERNAME $FTP_PASSWORD\nbye" | ftp -niv 2>&1)
    if echo "$RESULT" | grep -E "230|Login successful|logged in"; then
        echo -e "${GREEN}FTP credentials verified successfully!${RESET}"
    else
        echo -e "${RED}FTP login failed! Please check your credentials and try again.${RESET}"
        echo -e "${RED}FTP Output:${RESET}\n$RESULT"
        exit 1
    fi
}


echo -e "${CYAN}Do you want to install or uninstall the FTP uploader? (install/uninstall)${RESET}"
read ACTION
if [ "$ACTION" == "uninstall" ]; then
    uninstall
fi

# Prompt for dependency installation
echo -e "${YELLOW}First, we need to install dependencies [FTP, CURL] (y/n)${RESET}"
read depend
if [ "$depend" == "n" ]; then
    echo -e "${RED}Dependencies are required for the script to work correctly. Exiting installer.${RESET}"
    exit 0
fi

install_dependencies

echo -e "${YELLOW}Ok, now after the dependencies have been installed, you can now enter the FTP server details:"

#Getting the FTP and other info from user
echo -e "${CYAN}Enter FTP server address (e.g., ftp.example.org):${RESET}"
read FTP_SERVER
echo -e "${CYAN}Enter FTP username:${RESET}"
read FTP_USERNAME
echo -e "${CYAN}Enter FTP password:${RESET}"
echo -e "${RED}The password is hidden for your privacy ;)${RESET}"
read -s FTP_PASSWORD

test_ftp_credentials  # Validate FTP

echo -e "${CYAN}Enter local directory to upload (e.g., /srv/images):${RESET}"
read IMAGES_DIR
echo -e "${CYAN}Enter remote FTP directory path (e.g., /path/to/upload):${RESET}"
read REMOTE_DIR

echo -e "${CYAN}Enter installation directory (default: $HOME):${RESET}"
read INSTALL_DIR

INSTALL_DIR=${INSTALL_DIR:-$HOME} #If INSTALL_DIR is empty use the home directory
SCRIPT_PATH="$INSTALL_DIR/uploader.sh" # Make the full script path exist

# Create the script itself with all the data
echo -e "${YELLOW}Creating FTP uploader script at $SCRIPT_PATH...${RESET}"
cat <<EOF > "$SCRIPT_PATH"
#!/bin/bash

# FTP credentials/details
FTP_SERVER="$FTP_SERVER"
FTP_USERNAME="$FTP_USERNAME"
FTP_PASSWORD="$FTP_PASSWORD"

# Local directory to upload
IMAGES_DIR="$IMAGES_DIR"
REMOTE_DIR="$REMOTE_DIR"

# Connect to FTP server
ftp -n -i \$FTP_SERVER <<END_SCRIPT
quote USER \$FTP_USERNAME
quote PASS \$FTP_PASSWORD
cd \$REMOTE_DIR
binary
lcd \$IMAGES_DIR
mput *
quit
END_SCRIPT
EOF

# Make script executable
chmod +x "$SCRIPT_PATH"
echo -e "${GREEN}Script created and made executable.${RESET}"

# Set up cron job if needed
echo -e "${CYAN}Do you want to set up automatic execution via cron? (y/n)${RESET}"
read SETUP_CRON
if [ "$SETUP_CRON" == "y" ]; then
    echo -e "${CYAN}Enter schedule for cron job (default: daily at midnight '0 0 * * *'):${RESET}"
    read CRON_SCHEDULE
    CRON_SCHEDULE=${CRON_SCHEDULE:-"0 0 * * *"}
    (crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $SCRIPT_PATH") | crontab -
    echo -e "${GREEN}Cron job added to execute script automatically.${RESET}"
fi

echo -e "${CYAN}Do you want to run the script NOW? (y/n)${RESET}"
read testrun
if [ "$testrun" == "y" ]; then
    sh "$SCRIPT_PATH"
fi

echo -e "${GREEN}Setup complete! You can run the script manually with: $SCRIPT_PATH or if you enabled the schedule, wait for it to run on it's own automatically.${RESET}"
echo -e "${GREEN}You can also modify the script. Everything is written in the readme.md ;)${RESET}"
echo -e "${GREEN}Sooo enjoy the script and 73s DE OM1EPT FROM SLOVAKIA :D${RESET}"