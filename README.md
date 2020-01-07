# data-source-mjpg

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=for-the-badge)](https://github.com/nuvlabox/data-source-mjpg/graphs/commit-activity)


[![CI](https://img.shields.io/travis/com/nuvlabox/data-source-mjpg?style=for-the-badge&logo=travis-ci&logoColor=white)](https://travis-ci.com/nuvlabox/data-source-mjpg)
[![GitHub issues](https://img.shields.io/github/issues/nuvlabox/data-source-mjpg?style=for-the-badge&logo=github&logoColor=white)](https://GitHub.com/nuvlabox/data-source-mjpg/issues/)
[![Docker pulls](https://img.shields.io/docker/pulls/nuvlabox/data-source-mjpg?style=for-the-badge&logo=Docker&logoColor=white)](https://cloud.docker.com/u/nuvlabox/repository/docker/nuvlabox/data-source-mjpg)
[![Docker image size](https://img.shields.io/microbadger/image-size/nuvlabox/data-source-mjpg?style=for-the-badge&logo=Docker&logoColor=white)](https://cloud.docker.com/u/nuvlabox/repository/docker/nuvlabox/data-source-mjpg)

![logo](https://camo.githubusercontent.com/5f893cf6632a9d635c0bdb1c0b51fc97317ce498/68747470733a2f2f6d656469612e73697873712e636f6d2f68756266732f53697853715f47656e6572616c2f6e75766c61626f785f6c6f676f5f7265645f6f6e5f7472616e73706172656e745f3235303070782e706e67)



**This repository contains the source code for the NuvlaBox MJPG Data Source - this microservice is only deployed on-demand, and takes care of routing the raw MJPG data from a peripheral into the [NuvlaBox](https://sixsq.com/products-and-services/nuvlabox/overview)'s Data Gateway**


---

**NOTE:** this microservice is part of a loosely coupled architecture, thus when deployed by itself, it might not provide all of its functionalities. Please refer to https://github.com/nuvlabox/deployment and docs.nuvla.io for a fully functional deployment

---

## Build the NuvlaBox MJPG Data Source 

This repository is already linked with Travis CI, so with every commit, a new Docker image is released. 

There is a [POM file](pom.xml) which is responsible for handling the multi-architecture and stage-specific builds.

**If you're developing and testing locally in your own machine**, simply run `docker build .` or even deploy the microservice via the local [compose files](docker-compose.yml) to have your changes built into a new Docker image, and saved into your local filesystem.

**If you're developing in a non-master branch**, please push your changes to the respective branch, and wait for Travis CI to finish the automated build. You'll find your Docker image in the [nuvladev](https://hub.docker.com/u/nuvladev) organization in Docker hub, names as _nuvladev/data-source-mjpg:\<branch\>_.

## Deploy the NuvlaBox MJPG Data Source 

### Prerequisites 

 - *Docker (version 18 or higher)*
 - *Docker Compose (version 1.23.2 or higher)*

### Launching the NuvlaBox MJPG Data Source 

Simply run `docker-compose up --build`


## Test the NuvlaBox MJPG Data Source 

This component needs an existing NuvlaBox to be up and running before it can be deployed.

Once you have a fully functional NuvlaBox running, simply SSH into it, clone this repository and run `docker-compose up -d`.
 

## Contributing

This is an open-source project, so all community contributions are more than welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md)
 
## Copyright

Copyright &copy; 2020, SixSq Sàrl


