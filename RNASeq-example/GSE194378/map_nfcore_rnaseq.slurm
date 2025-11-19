#!/bin/bash
#SBATCH --job-name=map_378
#SBATCH --output=logs/map_%j.out
#SBATCH --error=logs/map_%j.err
#SBATCH --time=96:00:00
#SBATCH --cpus-per-task=40
#SBATCH --mem=200G
#SBATCH --nodes=1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=pshinde@lji.org

# -------------------------------------------------------------------------
# Environment setup
# -------------------------------------------------------------------------
#module purge
#module load singularity
#export PATH=$HOME/tools:$PATH

mkdir -p logs results work reports

# -------------------------------------------------------------------------
# Run nf-core/rnaseq (full mapping)
# -------------------------------------------------------------------------
nextflow run nf-core/rnaseq \
  -profile singularity \
  --input design.csv \
  --fasta  /home/pshinde/repos/cmi-flu/transcriptomics/GSE178158/reference/GRCh38.gencode.v47.strict/GCA_000001405.15_GRCh38_no_alt_analysis_set.edited.fa \
  --gtf    /home/pshinde/repos/cmi-flu/transcriptomics/GSE178158/reference/GRCh38.gencode.v47.strict/gencode.v47.primary_assembly.annotation.filtered.gtf \
  --aligner star_salmon \
  --outdir results \
  --max_cpus 40 \
  --max_memory '200.GB' \
  --skip_stringtie \
  --skip_bigwig \
  --skip_samtools_stats \
  --skip_markduplicates \
  --skip_preseq  \
  --skip_rseqc  \
  --validate_params false \
  -resume \
  -with-report "reports/map_report.html" \
  -with-timeline "reports/map_timeline.html" \
  -with-trace "reports/map_trace.txt"
