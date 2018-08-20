FROM genepattern/docker-r-3-13:0.1

#
# install R packages for the PreprocessDataset module 
#
COPY r.package.info /build/source/r.package.info
RUN Rscript --no-save --quiet --slave --no-restore \
    /build/source/installPackages.R \
    /build/source/r.package.info \
    /build/source/install.packages.log

# set R_HOME to /usr/lib/R
ENV R_HOME /usr/lib/R
