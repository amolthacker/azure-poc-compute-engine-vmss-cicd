#!/bin/bash

# Fetch EPEL RPM
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install Ansible
yum -y install ansible