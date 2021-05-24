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
KEY1=$MYKEY1
SECRET1=$MYSECRET1
 
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
      - job_name: dmesg-logs
        static_configs:
          - targets: [localhost]
            labels:
              job: dmesg
              __path__: /var/log/dmesg
      - job_name: ec2-logs
        ec2_sd_configs:
          - region: eu-west-2
            access_key: $MYKEY1
            secret_key: $MYSECRET1
        relabel_configs:
          - source_labels: [__meta_ec2_tag_Name]
            target_label: name
            action: replace
          - source_labels: [__meta_ec2_instance_id]
            target_label: instance_id
            action: replace
          - source_labels: [__meta_ec2_availability_zone]
            target_label: zone
            action: replace
          - action: replace
            replacement: /var/log/**.log
            target_label: __path__
          - source_labels: [__meta_ec2_private_dns_name]
            regex: "(.*)"
            target_label: instance

    clients:
      - url: https://$USER2:$PASS2@logs-prod-us-central1.grafana.net/loki/api/v1/push
EOF

# Run the agent
 
nohup ./agent-linux-amd64 --config.file=agent-config.yaml & 

