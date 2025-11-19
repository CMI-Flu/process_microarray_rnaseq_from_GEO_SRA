#!/bin/bash
#SBATCH --job-name=validate_nfcore_rnaseq
#SBATCH --output=logs/validate_%j.out
#SBATCH --error=logs/validate_%j.err
#SBATCH --time=20:00:00              # 1 hour should be plenty
#SBATCH --cpus-per-task=16
#SBATCH --mem=600G
#SBATCH --nodes=1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=pshinde@lji.org

# -------------------------------------------------------------------------
# Environment setup
# -------------------------------------------------------------------------
#module purge
#module load singularity
#export PATH=$HOME/tools:$PATH   # ensure it uses your Nextflow 25.04.8
#cd ~/repos/cmi-flu/transcriptomics/GSE178158
mkdir -p logs results work

# -------------------------------------------------------------------------
# Run nf-core/rnaseq (validation only)
# -------------------------------------------------------------------------
nextflow run nf-core/rnaseq \
-profile singularity \
--input design.csv \
--fasta  reference/GRCh38.gencode.v47.strict/GCA_000001405.15_GRCh38_no_alt_analysis_set.edited.fa \
--gtf    reference/GRCh38.gencode.v47.strict/gencode.v47.primary_assembly.annotation.filtered.gtf \
--star_index reference/GRCh38.gencode.v47.strict/STAR_GRCh38.gencode.v47.strict \
--aligner star_salmon \
--outdir results \
--max_cpus 16 \
--max_memory '600.GB' \
--skip_alignment \
--skip_qc \
--skip_preseq \
--skip_markduplicates \
--skip_rseqc \
--skip_trimming \
--validate_only \
-resume \
-with-report "reports/validate_report.html" \
-with-timeline "reports/validate_timeline.html" \
-with-trace "reports/validate_trace.txt"
