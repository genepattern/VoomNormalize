To build the image locally ...
  Template:
    $ docker image build --tag local/preprocessdataset:${version} .
  Example:
    $ docker image build --tag local/preprocessdataset:v0.7-pre.4 .

To publish in DockerHub ...
  Connect to DockerHub, select Create > Create Automated Build (from the drop down menu).

  Organization: genepattern
  Dockerfile Location: /docker

  Build rules:
    (1) branch: master,      dockerfile location: /docker, tag name: latest
    (2) branch: develop,     dockerfile location: /docker, tag name: Same as branch
    (3) tag: /^v[0-9.]+.*$/, dockerfile location: /docker, tag name: Same as tag

  See: https://docs.docker.com/docker-hub/builds/

