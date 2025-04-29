# Project Overview
Written by: Brennan Burke
## Contents

.github Directory:
This directory contains the docker-build2.yml file which is the workflow file that is referenced in README-CD.md
- docker-build2.yml is the workflow file used throughout Project 5.

Project4 Directory:
This directory is currently null, as anything important that originated here was transferred over to the [Project 5 Directory](https://github.com/WSU-kduncan/ceg3120-cicd-Brennnan12883/tree/main/Project5)

Project5 Directory: 
This directory contains all of the necessary files to run this project. This also contains both [README-CD.md (Continuous Deployment)](https://github.com/WSU-kduncan/ceg3120-cicd-Brennnan12883/blob/main/Project5/README-CD.md) and [README-CI.md (Continuous Implementation)](https://github.com/WSU-kduncan/ceg3120-cicd-Brennnan12883/blob/main/Project5/README-CI.md) Which are used to explain the majority of the project, as well as show steps to re-create them.
- Contains the angular-site content file, which allows the usage of the angular application.
- Contains the deployment directory, which has the contents to allow the usage of webhooks and payloads. This contains bash-deploy.sh, webhooks.json, and webhook.service.
- Contains the images directory, which houses the images used in the README files for this project.
- Contains the Dockerfile, which will allow Docker to cooperate with GitHub.
- Contains README-CI.md, which explains the steps to re-create a continous implementation setting on a local system. This file shows how to set up a Docker repository, as well as build a docker image and use the push and pull functions to update the image version on DockerHub.
- Contains README-CD.md, which explains the steps to re-create a continuous deployment setting with an EC2 instance, while allowing the usage of webhooks cooperating with GitHub events. Goes after the README-CI.md file chronologically.

