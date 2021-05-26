# grafana-agent-amd-linux

sudo yum install wget unzip git curl 

git clone https://github.com/aengusrooneygrafana/grafana-agent-amd-linux.git 

cd grafana-agent-amd-linux/ 

export PROM_PUBLISHER_KEY="my-grafana-dot-com-hosted-METRICS-key"   

export PROM_USER="my-grafana-dot-com-hosted-METRICS-user"

export LOKI_PUBLISHER_KEY="my-grafana-dot-com-hosted-LOGS-key"

export LOKI_USER="my-grafana-dot-com-hosted-LOGS-user"   

# if running on AWS EC2 

export AWSKEY="my-aws-access-key"

export AWSSECRET="my-aws-secret"

# run the agent 

./download-install-run-grafana-agent.sh 
