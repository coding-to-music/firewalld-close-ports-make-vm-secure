#!/bin/bash

# Define the Docker-related chains to be deleted
DOCKER_CHAINS=(
    "FWDI_docker"
    "FWDO_docker"
    "IN_docker"
    "FWDI_docker_allow"
    "FWDI_docker_deny"
    "FWDI_docker_log"
    "FWDI_docker_post"
    "FWDI_docker_pre"
    "FWDO_docker_allow"
    "FWDO_docker_deny"
    "FWDO_docker_log"
    "FWDO_docker_post"
    "FWDO_docker_pre"
    "IN_docker_allow"
    "IN_docker_deny"
    "IN_docker_log"
    "IN_docker_post"
    "IN_docker_pre"
)

# Delete the Docker-related chains
for chain in "${DOCKER_CHAINS[@]}"; do
    sudo iptables -X "$chain"
done

# Verify that Docker-related chains are deleted
sudo iptables -L | grep docker
