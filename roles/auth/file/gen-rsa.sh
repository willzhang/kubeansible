#!/bin/sh

if [ ! -f /root/.ssh/id_rsa ]; then
    echo "ssh-keygen id_rsa"
    ssh-keygen -t rsa -b 2048 -P '' -f /root/.ssh/id_rsa
fi