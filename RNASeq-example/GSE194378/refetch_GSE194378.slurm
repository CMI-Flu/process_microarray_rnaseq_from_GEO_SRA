#!/bin/bash
#SBATCH --job-name=refetch_GSE194378
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=200G
#SBATCH --array=1-412%10
#SBATCH --time=10:00:00
#SBATCH --output=logs/fetch_%A_%a.out
#SBATCH --error=logs/fetch_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=pshinde@lji.org

# -------------------------------------------------------------------------
# Environment setup
# -------------------------------------------------------------------------
export PATH=$HOME/tools/sratoolkit.3.2.1-ubuntu64/bin:$PATH
mkdir -p fastq logs tmp ~/ncbi/public/sra

ACC=$(sed -n "${SLURM_ARRAY_TASK_ID}p" SRR_accessions.txt)
echo "[$(date)] Starting process for accession: $ACC"

# -------------------------------------------------------------------------
# Step 1: Skip already completed samples
# -------------------------------------------------------------------------
if [ -f fastq/${ACC}_1.fastq.gz ]; then
  echo "[$(date)] Skipping $ACC (already downloaded and gzipped)"
  exit 0
fi

# -------------------------------------------------------------------------
# Step 2: Resumable download (.sra)
# -------------------------------------------------------------------------
echo "[$(date)] Prefetching $ACC (resumable)..."
prefetch --max-size 100G --progress $ACC
if [ $? -ne 0 ]; then
  echo "[$(date)] ERROR: prefetch failed for $ACC"
  exit 1
fi

# -------------------------------------------------------------------------
# Step 3: Validate SRA integrity
# -------------------------------------------------------------------------
echo "[$(date)] Validating $ACC..."
vdb-validate ~/ncbi/public/sra/${ACC}.sra
if [ $? -ne 0 ]; then
  echo "[$(date)] WARNING: validation failed for $ACC, retrying..."
  rm -f ~/ncbi/public/sra/${ACC}.sra
  prefetch --max-size 100G --progress $ACC
  vdb-validate ~/ncbi/public/sra/${ACC}.sra || { echo "[$(date)] ERROR: validation failed again for $ACC"; exit 1; }
fi

# -------------------------------------------------------------------------
# Step 4: Convert to FASTQ
# -------------------------------------------------------------------------
echo "[$(date)] Converting ${ACC}.sra to FASTQ..."
fasterq-dump --split-files --threads 4 --temp tmp ~/ncbi/public/sra/${ACC}.sra -O fastq/
if [ $? -ne 0 ]; then
  echo "[$(date)] ERROR: fasterq-dump failed for $ACC"
  exit 1
fi

# -------------------------------------------------------------------------
# Step 5: Check and compress FASTQ safely
# -------------------------------------------------------------------------
echo "[$(date)] Checking and compressing FASTQ files for $ACC..."
for f in fastq/${ACC}_*.fastq; do
  if [ ! -s "$f" ]; then
    echo "[$(date)] WARNING: $f is empty or missing. Skipping."
    continue
  fi

  LINES=$(wc -l < "$f")
  if [ $((LINES % 4)) -ne 0 ]; then
    echo "[$(date)] WARNING: $f appears incomplete (line count not multiple of 4). Skipping compression."
    continue
  fi

  gzip -v "$f"
  if gzip -t "${f}.gz" 2>/dev/null; then
    echo "[$(date)] Compression verified for ${f}.gz"
  else
    echo "[$(date)] ERROR: gzip verification failed for ${f}.gz"
  fi
done

# -------------------------------------------------------------------------
# Step 6: Optional cleanup of temporary files
# -------------------------------------------------------------------------
if [ -d tmp ]; then
  rm -rf tmp/*
fi

echo "[$(date)] Finished download and cleanup for $ACC"
