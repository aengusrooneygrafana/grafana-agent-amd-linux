#!/bin/bash 
# Grafana Agent for AMD64 Linux  

# Download and install the agent binary 
 
curl -O -L "https://github.com/grafana/agent/releases/latest/download/agent-linux-amd64.zip";
unzip "agent-linux-amd64.zip";
chmod a+x "$agent-linux-amd64";

# Set up the agent configurations 

export USER=
export PASS=
 
cat <<EOF > ./agent-config.yaml
integrations:
  node_exporter:
    enabled: true
  prometheus_remote_write:
    - basic_auth:
        password: $PASS
        username: $USER
      url: https://prometheus-us-central1.grafana.net/api/prom/push
prometheus:
  configs:
    - name: integrations
      remote_write:
        - basic_auth:
            password: $PASS 
            username: $USER 
          url: https://prometheus-us-central1.grafana.net/api/prom/push
  global:
    scrape_interval: 15s
  wal_directory: /tmp/grafana-agent-wal
server:
  http_listen_port: 12345
EOF

# Run the agent
 
nohup ./agent-linux-amd64 --config.file=agent-config.yaml & 

