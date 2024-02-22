#!/bin/bash

# Updating the package list
sudo apt-get update

# Installing prerequisites
sudo apt-get install -y apt-transport-https software-properties-common

# Step 2: Add the GPG Key for Grafana
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Step 3: Add Grafana Repository to the system source list
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Step 4: Update package list and install Grafana
sudo apt-get update
sudo apt-get -y install grafana

# Step 5: Enable and start the Grafana server service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Step 6: Checking the status of Grafana service
sudo systemctl status grafana-server
