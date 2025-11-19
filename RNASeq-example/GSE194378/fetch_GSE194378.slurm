#!/bin/bash
#SBATCH --job-name=fetch_GSE194378      # Job name
#SBATCH --nodes=1                        # Run on a single node
#SBATCH --ntasks=1                       # One main task
#SBATCH --cpus-per-task=4                # Use 4 CPU cores for fasterq-dump
#SBATCH --mem=200G                       # Total memory for this job
#SBATCH --array=1-412%10                # 412 total jobs, run 10 in parallel
#SBATCH --time=1:30:00                  # Maximum runtime (2 hours)
#SBATCH --output=logs/fetch_%A_%a.out    # Standard output (%A=job array ID, %a=array index)
#SBATCH --error=logs/fetch_%A_%a.err     # Error log
#SBATCH --mail-type=END,FAIL             # Email on job completion or failure
#SBATCH --mail-user=pshinde@lji.org      # Notification email

# -------------------------------------------------------------------------
# Environment setup
# -------------------------------------------------------------------------
export PATH=$HOME/tools/sratoolkit.3.2.1-ubuntu64/bin:$PATH
mkdir -p fastq logs

# -------------------------------------------------------------------------
# Select SRR accession for this array index
# -------------------------------------------------------------------------
ACC=$(sed -n "${SLURM_ARRAY_TASK_ID}p" SRR_accessions.txt)
echo "[$(date)] Starting download for accession: $ACC"

# -------------------------------------------------------------------------
# Download and compress FASTQ files
# -------------------------------------------------------------------------
fasterq-dump --split-files --threads 4 $ACC -O fastq/
gzip fastq/${ACC}_1.fastq fastq/${ACC}_2.fastq

echo "[$(date)] Finished download for $ACC"
# -------------------------------------------------------------------------
