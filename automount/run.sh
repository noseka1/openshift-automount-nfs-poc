#!/bin/bash

# Install automounter and nfs rpms
dnf install autofs nfs-utils -y

# Export settings as if autofs would be started by systemd
source /etc/sysconfig/autofs
export USE_MISC_DEVICE

mkdir -p /host/var/mnt/automount

# Create automount configuration
echo '/host/var/mnt/automount /etc/extra.nfs' > /etc/auto.master.d/extra.autofs
echo '* -rw nfs-server:/exports/&' > /etc/extra.nfs

# Start nfs daemons
/usr/sbin/blkmapd
/usr/sbin/rpc.gssd
/usr/sbin/sm-notify
/usr/sbin/rpc.statd
/usr/bin/rpcbind -w

# From the Kubernetes docs:
# Any volume mounts created by containers in pods must be destroyed (unmounted) by the containers on termination
# Link: https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation
trap '
  # kill all child processes
  trap - SIGTERM && kill -- -$$

  echo Trying to unmount volumes /host/var/mnt/*
  umount /host/var/mnt/automount/*
  echo Volumes successfully unmounted
  ' EXIT

# Start the autofs
automount \
  --foreground \
  --dont-check-daemon \
  --debug
