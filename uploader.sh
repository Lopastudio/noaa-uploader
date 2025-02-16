#!/bin/bash


#FTP credentials/details
FTP_SERVER="ftp_address_here (ftp.example.org)"
FTP_USERNAME="user_here"
FTP_PASSWORD="password_here"

#Local directory to upload
IMAGES_DIR="/srv/images"
REMOTE_DIR="/REPLACE_ME_WITH_YOUR_PATH_PLZ"

#Connect to FTP server
ftp -n -i $FTP_SERVER <<END_SCRIPT
quote USER $FTP_USERNAME
quote PASS $FTP_PASSWORD
cd $REMOTE_DIR
binary
lcd $IMAGES_DIR
mput *

quit
END_SCRIPT