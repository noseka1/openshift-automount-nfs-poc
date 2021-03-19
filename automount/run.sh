#!/bin/bash

# Install automounter and nfs rpms
dnf install autofs nfs-utils -y

# Export settings as if autofs would be started by systemd
source /etc/sysconfig/autofs
export USE_MISC_DEVICE

# Create automount configuration
echo '/host/var/mnt /etc/extra.nfs' > /etc/auto.master.d/extra.autofs
echo '* -rw nfs-server:/exports/&' > /etc/extra.nfs

# Start nfs daemons
/usr/sbin/blkmapd
/usr/sbin/rpc.gssd
/usr/sbin/sm-notify
/usr/sbin/rpc.statd
/usr/bin/rpcbind -w

# Start the autofs
automount \
  --foreground \
  --dont-check-daemon \
  --debug
