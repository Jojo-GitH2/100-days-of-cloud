#!/bin/bash
mkdir -p /root/.ssh
echo "ssh-rsa AAAAB3NzaC...[PASTE_PUBLIC_KEY_HERE]... root@aws-client" >> /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys