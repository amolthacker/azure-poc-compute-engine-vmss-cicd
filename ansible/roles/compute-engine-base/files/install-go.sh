#!/bin/bash

# Install Go
mkdir ~/downloads \
  && cd ~/downloads \
  && wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz \
  && tar -C /usr/local -xzf go1.8.linux-amd64.tar.gz

# Install Stress tool
wget ftp://fr2.rpmfind.net/linux/dag/redhat/el7/en/x86_64/dag/RPMS/stress-1.0.2-1.el7.rf.x86_64.rpm \
  && yum -y localinstall stress-1.0.2-1.el7.rf.x86_64.rpm

# Cleanup
rm -rf ~/downloads
