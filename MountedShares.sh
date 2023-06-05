#!/bin/bash
#test! 
# Define the delimiter
delimit="~~"

# Function to parse fstab entries
parse_fstab() {
    awk -v d="$delimit" '/^[^#]/ && ($3 == "cifs" || $3 == "nfs" || $3 == "ntfs") { print $1 d $2 d "fstab" }' /etc/fstab
}

# Function to parse mtab entries
parse_mtab() {
    awk -v d="$delimit" '($3 == "cifs" || $3 == "nfs" || $3 == "ntfs") { print $1 d $2 d "mtab" }' /etc/mtab
}

# Function to parse /proc/mounts
parse_proc_mounts() {
    awk -v d="$delimiter" '($3 == "cifs" || $3 == "nfs" || $3 == "ntfs") { print $1 d $2 d "/proc/mounts" }' /proc/mounts
}

# Function to parse mount command logs
parse_mount_command_logs() {
    grep -oE "mount\s+\S+" /var/log/messages* | awk -v d="$delimiter" '($3 == "cifs" || $3 == "nfs" || $3 == "ntfs") { print $2 d $3 d "logs" }' | sort -u
}

# Function to parse smb.conf entries
parse_smb_conf() {
    awk -F'=' -v d="$delimiter" '/^\[.*\]$/ { section=$1 } $1 == "path" { print $2 d $2 d "smb.conf" }' /etc/samba/smb.conf
}

# Parse and output fstab entries
parse_fstab

# Parse and output mtab entries
parse_mtab

# Parse and output /proc/mounts
parse_proc_mounts

# Parse and output mount command logs
parse_mount_command_logs

exit 0
