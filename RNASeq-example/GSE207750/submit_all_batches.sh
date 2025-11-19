#!/bin/bash
mkdir -p logs reports results

for BATCH in design_batch_*.csv; do
    echo "[$(date)] Submitting batch: $BATCH"
    sbatch run_rnaseq_batch.slurm "$BATCH"
done

echo "[$(date)] All batch jobs submitted."
