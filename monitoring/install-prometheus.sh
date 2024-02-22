#!/bin/bash

# Create a system user for Prometheus without home directory and shell access
sudo useradd --system --no-create-home --shell /bin/false prometheus

# Download Prometheus binary package
wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz

# Extract the downloaded package
tar -xvf prometheus-2.47.1.linux-amd64.tar.gz
cd prometheus-2.47.1.linux-amd64/

# Create required directories
sudo mkdir -p /data /etc/prometheus

# Move binaries to a directory in the PATH and set up configuration files
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml

# Set ownership to the Prometheus user for configuration and data directories
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/

# Create a systemd unit file for Prometheus
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/data \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries \\
  --web.listen-address=0.0.0.0:9090 \\
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF

# The systemd unit file defines how the Prometheus service should be started and managed

# Enable Prometheus service to start on boot
sudo systemctl enable prometheus

# Start Prometheus service
sudo systemctl start prometheus

# Check the status of the Prometheus service
sudo systemctl status prometheus
