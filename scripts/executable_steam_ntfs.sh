#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi
# Check if ntfs-3g is installed
if ! command -v ntfs-3g &>/dev/null; then
  echo "ntfs-3g could not be found, installing..."
  pacman -Syu --noconfirm ntfs-3g
fi
# Create mount point if it doesn't exist
MOUNT_POINT="/media/gamedisk"
if [ ! -d "$MOUNT_POINT" ]; then
  mkdir -p "$MOUNT_POINT"
fi
# Get the UUID of the NTFS partition (replace /dev/sdX1 with your actual partition)
PARTITION="/dev/nvme0n1p5"
UUID=$(blkid -s UUID -o value "$PARTITION")
if [ -z "$UUID" ]; then
  echo "Could not find UUID for partition $PARTITION"
  exit 1
fi
# Backup fstab before modifying
cp /etc/fstab /etc/fstab.bak
# Add entry to /etc/fstab if it doesn't already exist
if ! grep -q "$UUID" /etc/fstab; then
  echo "Adding $PARTITION to /etc/fstab"
  echo "UUID=$UUID $MOUNT_POINT lowntfs-3g defaults,uid=1000,gid=1000,dmask=027,fmask=137 0 0" >>/etc/fstab
else
  echo "Entry for $PARTITION already exists in /etc/fstab"
fi
# Mount the partition
mount "$MOUNT_POINT"
if [ $? -eq 0 ]; then
  echo "$PARTITION mounted successfully at $MOUNT_POINT"
else
  echo "Failed to mount $PARTITION"
  exit 1
fi
# End of script
