#!/usr/bin/env bash
echo "Installing nginx"
sudo apt-get update
sudo apt-get install -y nginx
echo "Moving the file"
sudo mv /home/ubuntu/default /etc/nginx/sites-available
echo "Restarting service"
sudo systemctl restart nginx
