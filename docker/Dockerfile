FROM genepattern/docker-r-3-13:0.1


# add this line to the Rprofile.site, needed to install packages from https sites
#   options(download.file.method = "wget")
# 
#RUN echo "\\noptions(download.file.method = \"wget\")\\n" >> /usr/local/lib/R/etc/Rprofile.site

#
# install R packages for the PreprocessDataset module 
#
COPY r.package.info /build/source/r.package.info
RUN Rscript --no-save --quiet --slave --no-restore \
    /build/source/installPackages.R \
    /build/source/r.package.info \
    /build/source/install.packages.log
