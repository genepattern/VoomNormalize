# VoomNormalize (v1.0)

Preprocess RNA-Seq count data in a GCT file so that it is suitable for use in GenePattern analyses.

**Authors:** Arthur Liberzon, David Eby, Edwin Juárez.

**Contact:** http://genepattern.org/help

## Introduction

This module is used to preprocess RNA-Seq data into a form suitable for use downstream in other GenePattern analyses such as GSEA, ComparativeMarkerSelection, NMFConsensus, as well as GENE-E and other visualizers.  Many of these tools were originally designed to handle microarray data - particularly from Affymetrix arrays - and so we must be mindful of that origin when preprocessing data for use with them.

The module does this by using a mean-variance modeling technique [1] to transform the dataset to fit an approximation of a normal distribution, with the goal of thus being able to apply classic normal-based microarray-oriented statistical methods and workflows.

## Algorithm

This modeling technique is called 'voom' and is part of the 'limma' package of Bioconductor [1] [2].  Use of this method requires the user to supply raw read counts as produced by HTSeq or RSEM.  These counts should not be normalized and also should not be RPKM or FPKM values.  The MergeHTSeqCounts module in GenePattern is capable of producing a suitable GCT from HTSeq output.

The module first performs a filtering pass on the dataset to remove any features (rows) without at least 1 read per million in _n_ of the samples, where _n_ is the size of the smallest group of replicates (recommended in [3]).  Note that this not a simple threshold on the count but rather a filtering using CPM (counts per million) values calculated just for this purpose.  The raw values are still used for variance modeling; these CPM values are only used for filtering and then subsequently discarded.  The module will automatically determine the smallest group of samples (_n_) based on their classifications in the user-supplied CLS file.

* The threshold level can be adjusted using the _expression.value.filter.threshold_  advanced parameter, though the default value follows the recommendations from [1] and [3] and should suffice for most users.

Next, the module performs normalization of the dataset using Trimmed Mean of M-values (TMM) [4] on the raw counts of any remaining features that pass the filter.  Finally, the module performs the mean-variance transformation to approximate a normal distribution using the 'voom' method of the 'limma' package, returning a new dataset with values in logCPM (log2 counts per million) that can be used with classic normal-based microarray-oriented statistical methods and workflows.

## References

1. Law CW, Chen Y, Shi W and Smyth GK (2014). "voom: precision weights unlock linear model analysis tools for RNA-seq read counts." _Genome Biology_, *15**:R29 ([link][30])
2. Smythe GK (2015). "Package 'limma'" [documentation][31] from Bioconductor 3.0.
3. Anders S, McCarthy DJ, Chen Y, Okoniewski M, Smyth GK, Huber W, Robinson MD (2013). " Count-based differential expression analysis of RNA sequencing data using R and Bioconductor." _Nat. Protocols_, **8**, 1765-1786. ([link][32])
4. Robinson, MD, and Oshlack, A (2010). A scaling normalization method for differential expression analysis of RNA-seq data. _Genome Biology_ **11**, R25
5. Ritchie ME, Phipson B, Wu D, Hu Y, Law CW, Shi W and Smyth GK (2015). "limma powers differential expression analyses for RNA-sequencing and microarray studies." _Nucleic Acids Research_, **43**(7), pp. e47.
6. Robinson MD, McCarthy DJ and Smyth GK (2010). edgeR: a Bioconductor package for differential expression analysis of digital gene expression data. _Bioinformatics_ **26**, 139-140
7. Chen Y, McCarthy DJ, Robinson MD and Smyth GK (2015). "Package 'edgeR'" [Users Guide][33] from Bioconductor 3.0.

## Parameters

| Name                                | Description                                                                                                                                      |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| input file *                        | A GCT file containing raw RNA-Seq counts, such as is produced by MergeHTSeqCounts                                                                |
| cls file *                          | A categorical CLS file specifying the phenotype classes for the samples in the GCT file.                                                         |
| output file *                       | Output file name                                                                                                                                 |
| expression value filter threshold * | Threshold to use when filtering CPM expression values; rows are kept only if the values (in CPM) for all columns are greater than this threshold |
* \- required

## Input Files

1. <input.file>  
A GCT file containing raw read counts for your RNA-Seq data.  
2. <cls.file>  
A categorical CLS file specifying the phenotype classes for the samples in the GCT.  

## Output Files

1. <output.file>  (by default, <input.file_basename>.preprocessed.gct  
A GCT file containing the preprocessed dataset.  Note that this may have fewer rows than the original GCT due to the filter.
2. log2_<output.file>  (by default, log2_<input.file_basename>.preprocessed.gct  
A GCT file containing the log2 normalized & preprocessed dataset.  Note that this may have fewer rows than the original GCT due to the filter.

## Example Data

Input:

- ftp://gpftp.broadinstitute.org/example_data/modules/PreprocessReadCounts/input/MergedHTSeqCounts_GSE52778.gct  

- ftp://gpftp.broadinstitute.org/example_data/modules/PreprocessReadCounts/input/MergedHTSeqCounts_GSE52778.cls  

## Requirements

The module requires R-3.1.3 with the 'getopt_1.20.0' and 'optparse_1.3.2' packages from CRAN and the 'limma' and 'edgeR' packages from Bioconductor 3.0.

Those packages are available in the Docker container https://hub.docker.com/r/genepattern/voomnormalize:1.0

## Platform Dependencies

**Task Type:**
Preprocess & Utilities

**CPU Type:**
any

**Operating System:**
any

**Language:**
R3.1.3

## Version Comments

| Version | Release Date | Description                      |
| ------- | ------------ | -------------------------------- |
| 1.0     | 2020-08-17   | Output now generates a log2 normalized and anti-logged counts (algorithm by default computes the log2)|
| 0.9     | 2019-01-29   | Renaming module to VoomNormalize |
| 0.4     | 2015-11-24   | Prerelease building towards Beta |

©2006-2020 Regents of the University of California, Broad Institute, MIT
