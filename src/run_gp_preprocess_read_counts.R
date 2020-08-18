# Copyright (c) 2003-2020 Regents of the University of California and Broad Institute. All rights reserved.

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
  make_option("--expression.value.filter.threshold", dest="expression.value.filter.threshold", type="numeric"),
  make_option("--output.file", dest="output.file")
  )

opt <- parse_args(OptionParser(option_list=option_list), positional_arguments=TRUE, args=arguments)
print(opt)
opts <- opt$options

source(file.path("/module", "common.R"))
source(file.path("/module", "gp_preprocess_read_counts.R"))

expression.value.filter.threshold <- as.numeric(opts$expression.value.filter.threshold)

# Load the GCT and CLS.
print(opts$input.file)
gct <- read.gct(opts$input.file)
cls <- read.cls(opts$cls.file)

GP.preprocess.read.counts(gct, cls, opts$voom.transform,
                          expression.value.filter.threshold, opts$output.file)

sessionInfo()
