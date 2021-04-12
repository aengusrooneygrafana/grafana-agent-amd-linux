# grafana-agent-amd-linux

sudo yum install wget unzip git curl 

git clone https://github.com/aengusrooneygrafana/grafana-agent-amd-linux.git 

cd grafana-agent-amd-linux/ 

export MYUSER1="<my-grafana-dot-com-hosted-METRICS-user>" 
  
export MYPASSWORD1="<my-grafana-dot-com-hosted-METRICS-password>" 

export MYUSER2="<my-grafana-dot-com-hosted-LOGS-user>" 
  
export MYPASSWORD2="<my-grafana-dot-com-hosted-LOGS-password>"

./download-install-run-grafana-agent.sh 
