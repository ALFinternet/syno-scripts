#! /bin/bash

# Steps to install:

# with trailing / please
SOURCE_DIR=/volume2/docker-ssd/wireguard-on-alpine/
DEST_DIR=/volume1/Externals/GDrive\ -\ ALFinternet/VPN/Wireguard/
DEST_DIR2=/volume1/Externals/OneDrive\ -\ FinchTech/_\ Personal/VPN/Wireguard/

cp -fr "$SOURCE_DIR"peer_* "$DEST_DIR"
cp -fr "$SOURCE_DIR"peer_* "$DEST_DIR2"

echo "Done copying to GDrive & OneDrive"