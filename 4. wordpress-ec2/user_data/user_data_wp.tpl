#!/bin/bash
sudo yum update -y

sudo yum install php -y
sudo yum install php-mysqli -y
sudo yum install mariadb105 -y

sudo systemctl start httpd
sudo systemctl enable httpd

sudo systemctl start php-fpm
sudo systemctl enable php-fpm

sudo chown -R apache:apache /var/www/html

mount=${efs_mount_target}

sudo su -c "cat <<EOF >> /etc/fstab
$mount:/ /var/www/html nfs defaults,_netdev 0 0
EOF
"

# Give instance time to start DNS service
sleep 60

sudo mount -a