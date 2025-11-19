# Gene Expression Data Processing Pipeline

## Overview

This repository contains the data processing pipeline for integrating **expression data** from public repositories (GEO, ImmPort) into harmonized, normalized expression matrices suitable for downstream analysis in **ImmuneSpace** and **CMi-Flu**. The pipeline supports both **microarray** and **RNA-seq** data.

The goal is to:

- Collect raw data files.
- Process and normalize data through standardized workflows.
- Generate consistent, analysis-ready expression matrices.
- Integrate corresponding metadata.

---

## Pipeline Workflow

The pipeline consists of two parallel branches depending on the data type:

### 1️⃣ Microarray Data Processing

1. **Data Collection**
   - Source: [GEO](https://www.ncbi.nlm.nih.gov/geo/), [ImmPort](https://www.immport.org/)
   - Download raw microarray files (e.g., CEL files for Affymetrix).

2. **Background Correction**
   - Apply background correction (e.g., RMA, MAS5 depending on platform).

3. **Generate Intensity Matrix**
   - Convert processed files into intensity matrices.

4. **Normalization**
   - Normalize intensity matrices (e.g., quantile normalization).

5. **Export Normalized Matrix**
   - Output normalized matrix for downstream use.

### 2️⃣ RNA-seq Data Processing

1. **Data Collection**
   - Source: [GEO](https://www.ncbi.nlm.nih.gov/geo/), [ImmPort](https://www.immport.org/)
   - Download raw FASTQ files.

2. **Quantification using nf-core/rnaseq**
   - Use [nf-core/rnaseq](https://nf-co.re/rnaseq) pipeline for alignment, quantification, and QC.
   - Output raw count matrices.

3. **Normalization**
   - Apply normalization (e.g., TPM, TMM, or DESeq2 normalization) to raw count matrices.

4. **Export Normalized Matrix**
   - Output normalized matrix for downstream use.

---

## Metadata Integration

- Metadata is collected alongside expression data.
- Harmonized metadata (subject IDs, study info, clinical data, sample details) is merged with expression matrices.
- Metadata and normalized matrices are loaded into ImmuneSpace.

---

## Dependencies

- Python >= 3.8
- R >= 4.1
- nf-core/rnaseq >= 3.12
- Nextflow >= 22.10.0
- GEOquery (R package)
- Affy, limma, oligo, lumi (R packages for microarray processing)
- DESeq2, edgeR, tximport (R packages for RNA-seq normalization)

---
