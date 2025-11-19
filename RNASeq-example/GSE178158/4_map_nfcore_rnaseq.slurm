#!/bin/bash
#SBATCH --job-name=map8158
#SBATCH --output=logs/map_%j.out
#SBATCH --error=logs/map_%j.err
#SBATCH --time=70:00:00
#SBATCH --cpus-per-task=48
#SBATCH --mem=300G
#SBATCH --nodes=1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=pshinde@lji.org

# -------------------------------------------------------------------------
# Environment setup
# -------------------------------------------------------------------------
#module purge
#module load singularity
#export PATH=$HOME/tools:$PATH

#cd ~/repos/cmi-flu/transcriptomics/GSE178158
mkdir -p logs results work reports

# -------------------------------------------------------------------------
# Run nf-core/rnaseq (full mapping)
# -------------------------------------------------------------------------
nextflow run nf-core/rnaseq \
  -profile singularity \
  --input design.csv \
  --fasta  reference/GRCh38.gencode.v47.strict/GCA_000001405.15_GRCh38_no_alt_analysis_set.edited.fa \
  --gtf    reference/GRCh38.gencode.v47.strict/gencode.v47.primary_assembly.annotation.filtered.gtf \
  --aligner star_salmon \
  --outdir results \
  --max_cpus 48 \
  --max_memory '300.GB' \
  --skip_stringtie \
  --skip_bigwig \
  --skip_samtools_stats \
  --skip_markduplicates \
  --skip_dupradar \
  --skip_preseq  \
  --skip_rseqc  \
  -resume \
  -with-report "reports/map_report.html" \
  -with-timeline "reports/map_timeline.html" \
  -with-trace "reports/map_trace.txt"
