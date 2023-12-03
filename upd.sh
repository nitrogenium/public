#!/bin/bash

# Add Jammy repository to sources list
sudo bash -c 'echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list'

# Add the PPA
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test

# Update package lists
sudo apt update

# Install the required packages
#sudo apt-get -o Dpkg::Options::="--force-confold" -y install g++-11
#sudo apt-get -o Dpkg::Options::="--force-confold" -y install gcc-11
sudo apt-get --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -q -y install libc6

# Print done when finished
message ok "Успешно обновлено"
