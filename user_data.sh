#!/bin/bash
apt update -y
# apt install -y curl git
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Example app deployment
git clone https://github.com/deekshithk-github/lms.git /home/ubuntu/app
cd /home/ubuntu/app
npm install
nohup npm start &
