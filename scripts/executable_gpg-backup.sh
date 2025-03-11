#!/bin/bash

# GPG Backup & Restore Script

BACKUP_DIR="gpg-backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

backup_gpg() {
    echo "🔒 Starting GPG key backup..."
    mkdir -p "$BACKUP_DIR/$TIMESTAMP"
    
    echo "🔑 Listing secret keys..."
    gpg --list-secret-keys --keyid-format LONG
    
    read -p "Enter the Key ID to backup (or 'all' for every key): " KEY_ID
    if [[ "$KEY_ID" == "all" ]]; then
        gpg --export --armor > "$BACKUP_DIR/$TIMESTAMP/all-public-keys.asc"
        gpg --export-secret-keys --armor > "$BACKUP_DIR/$TIMESTAMP/all-private-keys.asc"
    else
        gpg --export --armor "$KEY_ID" > "$BACKUP_DIR/$TIMESTAMP/public-key-$KEY_ID.asc"
        gpg --export-secret-keys --armor "$KEY_ID" > "$BACKUP_DIR/$TIMESTAMP/private-key-$KEY_ID.asc"
    fi
    
    echo "📂 Backing up ownertrust..."
    gpg --export-ownertrust > "$BACKUP_DIR/$TIMESTAMP/ownertrust.txt"
    
    echo "📂 Copying GPG config..."
    cp -r ~/.gnupg "$BACKUP_DIR/$TIMESTAMP/gnupg-config"
    
    echo "✅ Backup completed! Files saved in: $BACKUP_DIR/$TIMESTAMP"
}

restore_gpg() {
    echo "🔓 Starting GPG key restore..."
    read -p "Enter the backup folder path: " RESTORE_PATH
    
    if [[ ! -d "$RESTORE_PATH" ]]; then
        echo "❌ Invalid path. Exiting."
        exit 1
    fi
    
    echo "🔑 Importing keys..."
    gpg --import "$RESTORE_PATH"/*.asc
    
    echo "📂 Restoring GPG config..."
    cp -r "$RESTORE_PATH/gnupg-config" ~/.gnupg

    echo "🛡️  Restoring ownertrust..."
    gpg --import-ownertrust "$RESTORE_PATH/ownertrust.txt"
    
    echo "🔧 Fixing permissions..."
    chmod 700 ~/.gnupg
    chmod 600 ~/.gnupg/*
    
    echo "✅ Restore completed! Check your keys with: gpg --list-keys"
}


echo "GPG Backup & Restore Script"
echo "1. Backup GPG Keys"
echo "2. Restore GPG Keys"
read -p "Choose an option (1 or 2): " CHOICE

case $CHOICE in
    1)
        backup_gpg
        ;;
    2)
        restore_gpg
        ;;
    *)
        echo "❌ Invalid option. Exiting."
        ;;
esac

exit 0
