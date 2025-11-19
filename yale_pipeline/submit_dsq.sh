#!/bin/bash

# Set SLURM library path manually
export LD_LIBRARY_PATH=/opt/slurm/23.11.10/lib/slurm:$LD_LIBRARY_PATH

# Run dsq with your submission config
/vast/palmer/apps/avx2/software/dSQ/1.05/dsq \
  --job-file array_job_list.txt \
  -p pi_kleinstein \
  -c 2 \
  --mem-per-cpu 10g \
  --mail-type ALL \
  -o dsq-jobfile-%A_%a-%N.out \
  -t 1-0 \
  --submit