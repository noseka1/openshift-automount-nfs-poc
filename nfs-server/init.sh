#!/bin/bash

# Install nfs server utils
dnf install nfs-utils -y

# Make nfsd filesystem available with the container
mount -t nfsd nfds /proc/fs/nfsd

# Start nfs daemons
/usr/sbin/rpcbind -w
/usr/sbin/rpc.mountd -N 2 -V 3
/usr/sbin/rpc.nfsd -G 10 -N 2 -V 3
/usr/sbin/rpc.statd --no-notify

# Create exports
I=1000
for CITY in dallas tucson sandiego; do
  # Create exported directory if it doesn't exit
  mkdir -p /exports/$CITY
  # allow wide open access
  chmod 777 /exports/$CITY
  # Add the directory to the list of exported dirs
  echo "/exports/$CITY *(rw,fsid=$I,async,root_squash)" > /etc/exports.d/$CITY.exports
  # Each export must have a unique fsid
  ((I++))
done

# Export city directory via nfs
exportfs -a

# Show current nfs exports
showmount -e
