#!/bin/bash
sudo yum update -y

sudo yum install mariadb105 -y

mount=${efs_mount_target}

sudo su -c "cat <<EOF >> /etc/fstab
$mount:/ /mnt nfs defaults,_netdev 0 0
EOF
"

# Give instance time to start DNS service
sleep 60

sudo mount -a