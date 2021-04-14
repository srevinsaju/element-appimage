#!/bin/bash
set -eux


yum -y install sudo
useradd github
usermod -aG wheel github
sed -i 's,%wheel\tALL=(ALL)\tALL,%wheel\tALL=(ALL)\tNOPASSWD:ALL,g' /etc/sudoers
su - github


sudo yum -y update
sudo yum -y install git openssl gcc-c++ make gcc openssl-devel tcl sqlite-devel libsecret libsecret-devel wget
sudo yum -y install python3
sudo yum -y groupinstall "Development Tools"