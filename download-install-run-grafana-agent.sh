#!/bin/bash 
# Grafana Agent for AMD64 Linux  

# Download and install the agent binary 
 
curl -O -L "https://github.com/grafana/agent/releases/latest/download/agent-linux-amd64.zip";
unzip "agent-linux-amd64.zip";
chmod a+x "$agent-linux-amd64";

# Set up the agent configurations 

USER1=$MYUSER1
PASS1=$MYPASSWORD1
USER2=$MYUSER2
PASS2=$MYPASSWORD2
 
cat <<EOF > ./agent-config.yaml
integrations:
  node_exporter:
    enabled: true
  prometheus_remote_write:
    - basic_auth:
        password: $PASS1
        username: $USER1
      url: https://prometheus-us-central1.grafana.net/api/prom/push
prometheus:
  configs:
    - name: integrations
      remote_write:
        - basic_auth:
            password: $PASS1 
            username: $USER1 
          url: https://prometheus-us-central1.grafana.net/api/prom/push
  global:
    scrape_interval: 15s
  wal_directory: /tmp/grafana-agent-wal
server:
  http_listen_port: 12345
loki:
  configs:
  - name: default
    positions:
      filename: /tmp/positions.yaml
    scrape_configs:
      - job_name: varlogs
        static_configs:
          - targets: [localhost]
            labels:
              job: varlogs
              __path__: /var/log/*log
      - job_name: dmesg
        static_configs:
          - targets: [localhost]
            labels:
              job: dmesg
              __path__: /var/log/dmesg
    clients:
      - url: https://$USER2:$PASS2@logs-prod-us-central1.grafana.net/loki/api/v1/push
EOF

# Run the agent
 
nohup ./agent-linux-amd64 --config.file=agent-config.yaml & 

