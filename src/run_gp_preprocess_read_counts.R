## The Broad Institute
## SOFTWARE COPYRIGHT NOTICE AGREEMENT
## This software and its documentation are copyright (2015) by the
## Broad Institute/Massachusetts Institute of Technology. All rights are
## reserved.
##
## This software is supplied without any warranty or guaranteed support
## whatsoever. Neither the Broad Institute nor MIT can be responsible for its
## use, misuse, or functionality.

suppressMessages(suppressWarnings(library(getopt)))
suppressMessages(suppressWarnings(library(optparse)))
suppressMessages(suppressWarnings(library(limma)))
suppressMessages(suppressWarnings(library(edgeR)))

sessionInfo()

arguments <- commandArgs(trailingOnly=TRUE)

libdir <- arguments[1]

option_list <- list(
  make_option("--input.file", dest="input.file"),
  make_option("--cls.file", dest="cls.file"),
  make_option("--voom.transform", dest="voom.transform", type="logical", default=TRUE), # Not passed from commandLine for now
  make_option("--output.file", dest="output.file")
  )

opt <- parse_args(OptionParser(option_list=option_list), positional_arguments=TRUE, args=arguments)
print(opt)
opts <- opt$options

source(file.path(libdir, "common.R"))
source(file.path(libdir, "gp_preprocess_read_counts.R"))

# Load the GCT and CLS.
gct <- read.gct(opts$input.file)
cls <- read.cls(opts$cls.file)

GP.preprocess.read.counts(gct, cls, opts$voom.transform, opts$output.file)

sessionInfo()