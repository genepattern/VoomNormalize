## The Broad Institute
## SOFTWARE COPYRIGHT NOTICE AGREEMENT
## This software and its documentation are copyright (2015) by the
## Broad Institute/Massachusetts Institute of Technology. All rights are
## reserved.
##
## This software is supplied without any warranty or guaranteed support
## whatsoever. Neither the Broad Institute nor MIT can be responsible for its
## use, misuse, or functionality.

suppressMessages(suppressWarnings(library(limma)))
suppressMessages(suppressWarnings(library(edgeR)))

# Assumes GenePattern's common.R has been sourced, for functions to read/write GCT & CLS.
GP.preprocess.read.counts <- function(gct, cls, voom.transform,
                                      expression.value.filter.threshold, output.file) {

   # Filter out the rows with non-expressed genes from the GCT.
   #    from PMID=23975260
   #    "remove features without at least 1 read per million in n of the samples,
   #     where n is the size of the smallest group of replicates"
   # For simplicity, consider only genes expressed in all samples (replicates)

   # First, compute counts-per-million; we'll filter rows based on CPM.
   cpms <- cpm(gct$data)

   # Second, find the smallest group of samples from the phenotype class info in the CLS
   smallestGroup <- min(sapply(cls$names, function(x) { sum(x == cls$labels) }))

   # One-liners are great, but to break that down:
   # min(                  # Find the smallest value returned by the sub-expression...
   #     sapply(cls$names,    # Apply the following function to each of the unique names in the
   #                          # CLS, then simplify to a vector of the same length as cls$names...
   #            function(x) {    # Define the function used by sapply...
   #             sum(               # sum the TRUE values in the vector returned by the sub-expression...
   #                 x == cls$labels   # Exactly match strings in the vector; returns a vector of the
   #                                   # same length with TRUE or FALSE depending on match or no.
   #    ) }))              # Close all parens

   # Finally, filter out any rows where the genes are not expressed above the cutoff threshold.
   # This will give us a vector of the rows that pass the filter.
   i <- rowSums(cpms > expression.value.filter.threshold) >= smallestGroup

   # construct DGEList object.  Note that we use the RAW COUNTS from the original GCT here rather
   # than the CPMs computed above.  The 'voom' call expects raw counts...
   cds <- DGEList(gct$data[i, ], group = cls$labels, genes = gct$row.descriptions[i])

   # ... though we will do a TMM normalization step on the raw counts first.
   # Note that future versions may permit other normalization methods.
   d <- calcNormFactors(cds, method = "TMM")

   # VOOM transformation - applied to counts after TMM normalization
   # source: limma manual 15.3
   # produces object of EList class
   # the most important component in this object is
   # E = MATRIX NUMERIC of normalized log2 expression values
   if (voom.transform) {
      dv <- voom(d, group = cls$labels, genes = gct$row.descriptions[i])
      gct$data <- dv$E
      gct$row.descriptions <- unlist(dv$genes)
   } else {
      # This is not implemented yet; it's an open question whether we'll allow this.
      gct$data <- d$counts
      gct$row.descriptions <- unlist(d$genes)
   }
   print(output.file)
   write.gct(gct, file.path(getwd(), paste('log2_',output.file,sep='')))
   # Anti-log the gct data

   gct$data <- round(2^(gct$data),2)
   write.gct(gct, file.path(getwd(), output.file))

}
