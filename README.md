# grafana-agent-amd-linux

sudo yum install wget unzip git curl 

git clone https://github.com/aengusrooneygrafana/grafana-agent-amd-linux.git 

cd grafana-agent-amd-linux/ 

export MYUSER=<my-grafana-dot-com-hosted-metrics-user> 
  
export MYPASSWORD=<my-grafana-dot-com-hosted-metrics-password>

./download-install-run-grafana-agent.sh 
