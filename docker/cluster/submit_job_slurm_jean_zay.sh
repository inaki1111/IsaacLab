#!/usr/bin/env bash

# in the case you need to load specific modules on the cluster, add them here
# e.g., `module load eth_proxy`

# create job script with compute demands
### MODIFY HERE FOR YOUR JOB ###
cat <<EOT > job.sh
#!/bin/bash
#SBATCH --mail-type=END
#SBATCH --mail-user=pia.bideau@inria.fr
#SBATCH --job-name="training-$(date +"%Y-%m-%dT%H:%M")"
#SBATCH --output="training-$(date +"%Y-%m-%dT%H:%M")-%j.out"
#SBATCH --output="training-$(date +"%Y-%m-%dT%H:%M")-%j.err"
#SBATCH --constraint=v100-16g # reserve GPUs with 16 GB of RAM
#SBATCH --nodes=1 # reserve 1 node
#SBATCH --ntasks=1 # reserve 4 tasks (or processes)
#SBATCH --gres=gpu:1 # reserve 4 GPUs
#SBATCH --cpus-per-task=8 # reserve 10 CPUs per task (and associated memory)
#SBATCH --time=01:00:00 # maximum allocation time "(HH:MM:SS)"
#SBATCH --qos=qos_gpu-dev # QoS
#SBATCH --hint=nomultithread # deactivate hyperthreading
#SBATCH --account=tuy@v100 # V100 accounting

# Pass the container profile first to run_singularity.sh, then all arguments intended for the executed script
bash "$1/docker/cluster/run_singularity.sh" "$1" "$2" "${@:3}"
EOT

sbatch < job.sh
rm job.sh
