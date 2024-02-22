#!/bin/bash

# Adding a system user for Node Exporter without home directory and shell access
sudo useradd --system --no-create-home --shell /bin/false node_exporter

# Downloading the Node Exporter binary package
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

# Extracting the Node Exporter package
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz

# Moving the Node Exporter binary to /usr/local/bin and cleaning up the workspace
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.6.1.linux-amd64 node_exporter-1.6.1.linux-amd64.tar.gz

# Creating a systemd service file for Node Exporter
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter --collector.logind

[Install]
WantedBy=multi-user.target
EOF

# The systemd service file is created with the required configuration for Node Exporter

# Enabling the Node Exporter service to start on boot
sudo systemctl enable node_exporter

# Starting the Node Exporter service
sudo systemctl start node_exporter

# Verifying the status of the Node Exporter service
sudo systemctl status node_exporter
