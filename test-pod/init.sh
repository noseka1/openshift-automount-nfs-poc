#!/bin/bash

echo Trying to write to data to an automounted volume
echo $(date) Hello from $HOSTNAME >> /mnt/automount/dallas/$HOSTNAME
