#!/bin/bash

: ${SSH_USERNAME:=user}
: ${SSH_USERPASS:=$(dd if=/dev/urandom bs=1 count=15 | base64)}

__create_rundir() {
	mkdir -p /var/run/sshd
}

__create_user() {
# Create a user to SSH into as.
useradd $SSH_USERNAME
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_USERNAME)
echo ssh user password: $SSH_USERPASS
chown -R $SSH_USERNAME:$SSH_USERNAME /home/$SSH_USERNAME/.ssh
chmod 700 /home/$SSH_USERNAME/.ssh
chmod 600 /home/$SSH_USERNAME/.ssh/*
}

__create_hostkeys() {
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
#ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' 
ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' 
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' 
}

# Call all functions
__create_rundir
__create_hostkeys
__create_user

exec "$@"

