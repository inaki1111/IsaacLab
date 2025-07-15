#!/usr/bin/env bash

# in the case you need to load specific modules on the cluster, add them here
# e.g., `module load eth_proxy`

# create job script with compute demands
### MODIFY HERE FOR YOUR JOB ###
cat <<EOT > job.sh
#!/bin/bash
#OAR -n "training-$(date +"%Y-%m-%dT%H:%M")"
#OAR -O "training-$(date +"%Y-%m-%dT%H:%M")-%j.out"
#OAR -E "training-$(date +"%Y-%m-%dT%H:%M")-%j.err"
#OAR -p "gpumodel='rtxA5000'" # reserve GPUs with 16 GB of RAM
#OAR -l nodes=1 # reserve 1 node
#OAR -l walltime=01:00:00 # maximum allocation time "(HH:MM:SS)"
#OAR -t besteffort

# Pass the container profile first to run_singularity.sh, then all arguments intended for the executed script
bash "$1/docker/cluster/run_singularity.sh" "$1" "$2" "${@:3}"
EOT

oarsub job.sh
rm job.sh
