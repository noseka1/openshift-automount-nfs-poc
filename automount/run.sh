#!/bin/bash

# Install automounter and nfs rpms
dnf install --assumeyes \
  autofs \
  nfs-utils \
  openldap-clients # currently unused

mkdir -p /host/var/mnt/automount

# Start the autofs
exec automount \
  --foreground \
  --dont-check-daemon \
  --debug
