#!/bin/bash

# Define the content to put in /etc/docker/daemon.json
#add ##server in your /etc/hosts , and this bash read server after that
DOCKER_DAEMON_JSON_CONTENT='{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "insecure-registries" : ["[registryIP]:[PORT]"]
}'

# Read the list of servers from /etc/hosts after the line ##server
# Adjust the grep pattern if necessary to match the format of your servers
SERVERS=$(awk '/##server/ {flag=1; next} flag {print $1}' /etc/hosts | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}|[a-zA-Z0-9._-]+')

# Function to update /etc/docker/daemon.json on a remote host
update_docker_daemon_json() {
  local server=$1
  echo "Updating Docker daemon.json on $server..."

  # SSH into the server, create /etc/docker/daemon.json if it doesn't exist, and populate it with the content
  ssh "$server" "sudo mkdir -p /etc/docker && echo '$DOCKER_DAEMON_JSON_CONTENT' | sudo tee /etc/docker/daemon.json > /dev/null"

  if [ $? -eq 0 ]; then
    echo "Successfully updated $server."
  else
    echo "Failed to update $server."
  fi
}

# Loop over each server and apply the update
for server in $SERVERS; do
  update_docker_daemon_json "$server"
done
