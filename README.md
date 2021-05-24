# grafana-agent-amd-linux

sudo yum install wget unzip git curl 

git clone https://github.com/aengusrooneygrafana/grafana-agent-amd-linux.git 

cd grafana-agent-amd-linux/ 

export MYUSER1="my-grafana-dot-com-hosted-METRICS-user" 

export MYPASSWORD1="my-grafana-dot-com-hosted-METRICS-password" 

export MYUSER2="my-grafana-dot-com-hosted-LOGS-user"   

export MYPASSWORD2="my-grafana-dot-com-hosted-LOGS-password"

# if running on AWS EC2 

export MYKEY1="my-aws-access-key"

export MYSECRET1="my-aws-secret"

# run the agent 

./download-install-run-grafana-agent.sh 
