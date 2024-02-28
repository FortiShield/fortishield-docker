docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=fortishield-indexer-data-1 \
           $2_fortishield-indexer-data-1

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=fortishield-indexer-data-2 \
           $2_fortishield-indexer-data-2

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=fortishield-indexer-data-3 \
           $2_fortishield-indexer-data-3

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master_fortishield_api_configuration \
           $2_master_fortishield_api_configuration

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master_fortishield_etc \
           $2_docker_fortishield_etc

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master-fortishield-logs \
           $2_master-fortishield-logs

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master-fortishield-queue \
           $2_master-fortishield-queue

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master-fortishield-var-multigroups \
           $2_master-fortishield-var-multigroups

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master-fortishield-integrations \
           $2_master-fortishield-integrations

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master-fortishield-active-response \
           $2_master-fortishield-active-response

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master-fortishield-agentless \
           $2_master-fortishield-agentless

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master-fortishield-wodles \
           $2_master-fortishield-wodles

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master-filebeat-etc \
           $2_master-filebeat-etc

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=master-filebeat-var \
           $2_master-filebeat-var

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker_fortishield_api_configuration \
           $2_worker_fortishield_api_configuration

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker_fortishield_etc \
           $2_worker-fortishield-etc

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker-fortishield-logs \
           $2_worker-fortishield-logs

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker-fortishield-queue \
           $2_worker-fortishield-queue

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker-fortishield-var-multigroups \
           $2_worker-fortishield-var-multigroups

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker-fortishield-integrations \
           $2_worker-fortishield-integrations

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker-fortishield-active-response \
           $2_worker-fortishield-active-response

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker-fortishield-agentless \
           $2_worker-fortishield-agentless

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker-fortishield-wodles \
           $2_worker-fortishield-wodles

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker-filebeat-etc \
           $2_worker-filebeat-etc

docker volume create \
           --label com.docker.compose.project=$2 \
           --label com.docker.compose.version=$1 \
           --label com.docker.compose.volume=worker-filebeat-var \
           $2_worker-filebeat-var

docker container run --rm -it \
           -v fortishield-docker_worker-filebeat-var:/from \
           -v $2_worker-filebeat-var:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_elastic-data-1:/from \
           -v $2_fortishield-indexer-data-1:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_elastic-data-2:/from \
           -v $2_fortishield-indexer-data-2:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_elastic-data-3:/from \
           -v $2_fortishield-indexer-data-3:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_ossec-api-configuration:/from \
           -v $2_master-fortishield-api-configuration:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_ossec-etc:/from \
           -v $2_master-fortishield-etc:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_ossec-logs:/from \
           -v $2_master-fortishield-logs:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_ossec-queue:/from \
           -v $2_master-fortishield-queue:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_ossec-var-multigroups:/from \
           -v $2_master-fortishield-var-multigroups:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_ossec-integrations:/from \
           -v $2_master-fortishield-integrations:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_ossec-active-response:/from \
           -v $2_master-fortishield-active-response:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_ossec-agentless:/from \
           -v $2_master-fortishield-agentless:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_ossec-wodles:/from \
           -v $2_master-fortishield-wodles:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_filebeat-etc:/from \
           -v $2_master-filebeat-etc:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_filebeat-var:/from \
           -v $2_master-filebeat-var:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-ossec-api-configuration:/from \
           -v $2_worker-fortishield-api-configuration:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-ossec-etc:/from \
           -v $2_worker-fortishield-etc:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-ossec-logs:/from \
           -v $2_worker-fortishield-logs:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-ossec-queue:/from \
           -v $2_worker-fortishield-queue:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-ossec-var-multigroups:/from \
           -v $2_worker-fortishield-var-multigroups:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-ossec-integrations:/from \
           -v $2_worker-fortishield-integrations:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-ossec-active-response:/from \
           -v $2_worker-fortishield-active-response:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-ossec-agentless:/from \
           -v $2_worker-fortishield-agentless:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-ossec-wodles:/from \
           -v $2_worker-fortishield-wodles:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-filebeat-etc:/from \
           -v $2_worker-filebeat-etc:/to \
           alpine ash -c "cd /from ; cp -avp . /to"

docker container run --rm -it \
           -v fortishield-docker_worker-filebeat-var:/from \
           -v $2_worker-filebeat-var:/to \
           alpine ash -c "cd /from ; cp -avp . /to"
