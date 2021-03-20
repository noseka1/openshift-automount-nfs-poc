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

# Create directories
for CITY in dallas tucson sandiego; do
  # Create exported directory if it doesn't exit
  mkdir -p /exports/$CITY
  # allow wide open access
  chmod 777 /exports/$CITY
  # create a test file
  echo $CITY > /exports/$CITY/$CITY.txt
done

# Add the exports directory to the list of exported dirs
echo "/exports *(rw,fsid=0,async,root_squash)" > /etc/exports.d/city.exports

# Export city directory via nfs
exportfs -r

# Show current nfs exports
showmount -e
