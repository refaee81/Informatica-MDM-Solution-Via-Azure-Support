#!/bin/bash

# Install necessary tools
sudo yum update -y
sudo yum install -y cifs-utils keyutils jq

# sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
# sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
# sudo dnf install azure-cli

# Define storage account and file share details
STORAGE_ACCOUNT_NAME=${storage_account_name}
FILE_SHARE_NAME=${fileshare_name}
FILE_HOST="$STORAGE_ACCOUNT_NAME.file.core.windows.net"
STORAGE_ACCOUNT_KEY="fakekey"
# Mount the Azure file share
MNT_ROOT="/mnt"
MNT_PATH="$MNT_ROOT/$STORAGE_ACCOUNT_NAME/$FILE_SHARE_NAME"

# Ensure port 445 is open
nc -zvw3 $FILE_HOST 445

sudo mkdir -p $MNT_PATH

# Mount the file share
SMB_PATH="//$FILE_HOST/$FILE_SHARE_NAME"
sudo mount -t cifs $SMB_PATH $MNT_PATH -o vers=3.0,username=$STORAGE_ACCOUNT_NAME,password=$STORAGE_ACCOUNT_KEY,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30,mfsymlinks



