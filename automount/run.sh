#!/bin/bash

# Install automounter and nfs rpms
dnf install --assumeyes \
  autofs \
  nfs-utils \
  openldap-clients # currently unused

mkdir -p /host/var/mnt/automount

# Create automount configuration
cat >/etc/auto.master.d/extra.autofs <<EOF
/host/var/mnt/automount /etc/extra.nfs
EOF
# REPLACE with the your NFS server IP address
cat >/etc/extra.nfs <<EOF
* -rw 10.129.2.4:/exports/&
EOF

# Start the autofs
exec automount \
  --foreground \
  --dont-check-daemon \
  --debug
