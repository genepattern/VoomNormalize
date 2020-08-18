FROM genepattern/docker-r-3-13:0.1

#
# install R packages for the VoomNormalize module
#
COPY docker/r.package.info /build/source/r.package.info
RUN Rscript --no-save --quiet --slave --no-restore \
    /build/source/installPackages.R \
    /build/source/r.package.info \
    /build/source/install.packages.log

# set R_HOME to /usr/lib/R
ENV R_HOME /usr/lib/R

#2020-08-07 Adding VoomNormalize code here
RUN mkdir /module
COPY src /module

# Build as:
# docker build --tag genepattern/voomnormalize:1.0 .
