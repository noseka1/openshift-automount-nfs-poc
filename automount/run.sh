#!/bin/bash

# Install automounter and nfs rpms
dnf install --assumeyes \
  autofs \
  nfs-utils \
  openldap-clients # currently unused

# Export settings as if autofs would be started by systemd
source /etc/sysconfig/autofs
export USE_MISC_DEVICE

mkdir -p /host/var/mnt/automount

# Create automount configuration
echo '/host/var/mnt/automount /etc/extra.nfs' > /etc/auto.master.d/extra.autofs
echo '* -rw 10.129.2.4:/exports/&' > /etc/extra.nfs

# Start the autofs
exec automount \
  --foreground \
  --dont-check-daemon \
  --debug
