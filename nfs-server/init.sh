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

# Export home directory via nfs
echo '/home/toolbox *(rw,async,no_root_squash)' > /etc/exports.d/toolbox.exports
exportfs -a

# Show current nfs exports
showmount -e
