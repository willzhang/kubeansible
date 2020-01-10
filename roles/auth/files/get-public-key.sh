#!/bin/sh

host=$1
if [[ `cat /root/.ssh/known_hosts | grep ecdsa-sha2-nistp256 | grep -E "\[{0,1}$host[], ]" | wc -l` -eq 0 ]]; then
    echo "ssh-keyscan $host"
    ssh-keyscan -t ecdsa-sha2-nistp256 $host >> /root/.ssh/known_hosts
fi