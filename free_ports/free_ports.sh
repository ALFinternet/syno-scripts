#! /bin/bash

# NEWLY ADDED BACKUP FUNCTIONALITY IS NOT FULLY TESTED YET, USE WITH CARE, ESPECIALLY DELETION
# Developed for DSM 6 - 7.0.1. Not tested on other versions.
# Steps to install:
# Save this script in one of your shares
# Edit it according to your requirements
# Backup /usr/syno/share/nginx/ as follows:
# Run this script as root
# Reboot and ensure everything is still working
# If not, restore the backup and post a comment on this script's gist page
# If it did, schedule it to run as root at boot through Control Panel -> Task Scheduler
#
# find files with 443 in them: grep 443 /usr/syno/share/nginx/*.mustache
# view in use ports: netstat -plnt | grep ":443"
# 
# stolen from from: https://gist.github.com/hjbotha/f64ef2e0cd1e8ba5ec526dcd6e937dd7
# additional info limiting files required to be modified: https://www.reddit.com/r/synology/comments/ahs3xh/prevent_dsm_listening_on_port_80443/

HTTP_PORT=5080
HTTPS_PORT=50443

BACKUP_FILES=true # change to false to disable backups
BACKUP_DIR=/volume1/syno-scripts/free_ports/backups
DELETE_OLD_BACKUPS=false # change to true to automatically delete old backups.
KEEP_BACKUP_DAYS=90

DATE=$(date +%Y-%m-%d-%H-%M-%S)
CURRENT_BACKUP_DIR="$BACKUP_DIR/$DATE"

if [ "$BACKUP_FILES" == "true" ]; then
  mkdir -p "$CURRENT_BACKUP_DIR"
  cp /usr/syno/share/nginx/*.mustache "$CURRENT_BACKUP_DIR"
fi

if [ "$DELETE_OLD_BACKUPS" == "true" ]; then
  find "$BACKUP_DIR/" -type d -mtime +$KEEP_BACKUP_DAYS -exec rm -r {} \;
fi

sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)80\([^0-9]\)/\1$HTTP_PORT\2/" /usr/syno/share/nginx/*.mustache
sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)443\([^0-9]\)/\1$HTTPS_PORT\2/" /usr/syno/share/nginx/*.mustache

if which synoservicecfg; then
  synoservicecfg --restart nginx
else
  synosystemctl restart nginx
fi

echo "Made these changes:"

diff /usr/syno/share/nginx/ $CURRENT_BACKUP_DIR 2>&1 | tee $CURRENT_BACKUP_DIR/changes.log
