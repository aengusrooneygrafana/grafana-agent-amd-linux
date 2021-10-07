#!/bin/bash 
# Grafana Agent for AMD64 Linux  

# Download and install the agent binary 
 
curl -O -L "https://github.com/grafana/agent/releases/latest/download/agent-linux-amd64.zip";
unzip "agent-linux-amd64.zip";
chmod a+x "agent-linux-amd64";

# Set up the agent configurations 
 
cat <<EOF > ./agent-config.yaml
integrations:
  node_exporter:
    enabled: true
  prometheus_remote_write:
    - basic_auth:
        password: $PROM_PUBLISHER_KEY
        username: $PROM_USER
      url: https://prometheus-us-central1.grafana.net/api/prom/push
prometheus:
  global:
    scrape_interval: 15s
  wal_directory: /tmp/grafana-agent-wal
  configs:
    - name: integrations
      remote_write:
        - basic_auth:
            password: $PROM_PUBLISHER_KEY
            username: $PROM_USER
          url: https://prometheus-us-central1.grafana.net/api/prom/push
    - name: ec2-configurations
      remote_write:
        - basic_auth:
            password: $PROM_PUBLISHER_KEY
            username: $PROM_USER
          url: https://prometheus-us-central1.grafana.net/api/prom/push
      scrape_configs:
        - job_name: ec2-metrics
          ec2_sd_configs:
            - region: eu-west-2
              access_key: $AWSKEY
              secret_key: $AWSSECRET
          static_configs:
            - targets: ['localhost:8080']
          relabel_configs:
            - source_labels: [__meta_ec2_tag_Name]
              target_label: name
              action: replace
            - source_labels: [__meta_ec2_instance_id]
              regex: "(.*)"
              target_label: instance_id
              action: replace
            - source_labels: [__meta_ec2_availability_zone]
              target_label: zone
              action: replace
            - source_labels: [__meta_ec2_private_ip]
              target_label: instance_private_ip
              action: replace
            - source_labels: [__meta_ec2_private_dns_name]
              regex: "(.*)"
              target_label: instance_private_dns_name
              action: replace
            - source_labels: [__meta_ec2_public_ip]
              target_label: instance_public_ip
              action: replace
            - source_labels: [__meta_ec2_public_dns_name]
              regex: "(.*)"
              target_label: instance_public_dns
              action: replace
#
server:
  http_listen_port: 12345
#
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
            access_key: $AWSKEY
            secret_key: $AWSSECRET
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
            target_label: instance_private_dns_name

    clients:
      - url: https://$LOKI_USER:$LOKI_PUBLISHER_KEY@logs-prod-us-central1.grafana.net/loki/api/v1/push
EOF

# Remove any previous process 
sudo kill agent-linux-amd
# Run the agent
sudo nohup ./agent-linux-amd64 --config.file=agent-config.yaml & 

