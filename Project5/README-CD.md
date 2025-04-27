# Project 5
Written By: Brennan Burke

Disclaimer: My EC2 instance IP kept changing each time that it restarted, I found it fairly easy to just adjust to the new IP and unfortunately never made a static IP. This is why the IP changes in the commands listed in this project.

## Part 1

1. Tagging in a GitHub repository
   - In order to see all tags locally, use the command `git tag`.
   - In order to generate a tag for a repository, do `git tag -a v*.*.* -m "(message)'`
   - In order to push a tag to GitHub, do `git push origin v*.*.*(typically the version just created)`
2. Container Images
   - The workflow is triggered whenever a tag with a correctly formatted version (v*.*.*) is pushed to the repository. Once the workflow is triggered, it:
      1. Grabs the version from the tag (v*,v*.*,v*.*.*)
      2. Builds a docker image from the repo
      3. Authenticates into DockerHub with your secrets submitted to GitHub
      4. Pushes the image onto DockerHub with the tags "latest","major","major.minor","major.minor.patch"
   - Explanation of the steps of the workflow:
     - `actions/checkout@v4` will clone the repository to allow workflow access to the contents.
     - `docker/metadata-action@v5` will read the Git tag.
     - `docker/login-action@v3` will login to DockerHub using your added secrets.
     - `docker/build-push-action@v5` will build a docker image from the Dockerfile and push it to Dockerhub.
   - Values that may need updated if changing repository:
     - Make sure to change the `images: edgyduck/burke-ceg3120` to your image. 
     - Also make sure to add your DOCKER_USERNAME and DOCKER_TOKEN to your GitHub secrets.
   - Link to workflow file: https://github.com/WSU-kduncan/ceg3120-cicd-Brennnan12883/blob/main/Project5/.github/workflows/docker-build.yml
3. Testing
   - Testing if your workflow workedflowed
     - Go to the actions tab of your repo in GitHub, click on your workflow file, and if there are no errors then it should have worked.
     - For DockerHub, run `docker pull edgyduck/burke-ceg3120:latest` then run the latest with `docker run --rm edgyduck/burke-ceg3120:latest` and if an output is seen, it worked.
    
## Part 2

1. EC2 Instance Details
   - AMI used: Ubuntu Server 24.04 LTS
   - Instance Type: t2.medium
   - Key: P5-Key.pem
   - Storage: 30 GiB of gp3
   - Security Group:
     - Allowed SSH from my home IP and Wright State IP.
     - Allowed HTTP for all IPs.
     - Created a Custom TCP to allow access to port 4200 from both my home IP and Wright State IPs.
     - Allowed TCP for port 9000 to allow webhook payloads, started with allowing from all IPs to make sure it works.
   - Security Group Justification:
     - Set SSH to Home IP and Wright State IP for better security.
     - Allowed HTTP access from all IPs to allow for usage of the angular app and to receive information from the internet.
     - Allowed TCP acces to port 4200 to allow Docker to run on port 4200 from both my home IP and Wright State's IPs.
     - Allowed access to port 9000 from all IPs to let webhook payloads work, but will change the IP access to the Docker Local IP when set up.
2. Setting up Docker inside of the EC2 Instance
   - To install Docker on your instance, assuming you have a fresh instance, run:
```
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```
   - Test if Docker is working by running `docker --version` and/or `docker run hello-world`.
   - Since I am running on Ubuntu, I needed to run:
     - `sudo npm install` to install npm and its dependencies.
     - `sudo npm install -g @angular/cli` to install angular and its dependencies.
   - I ran the command `docker run -it --rm -p 4200:4200 edgyduck/burke-ceg3120:latest` to run my image.

3. Testing the EC2 Instance
   - In order to pull the latest version of the Docker Image, run `docker pull edgyduck/burke-ceg3120:latest`.
   - In order to run the container from the image, run `docker run -it --rm -p 4200:4200 edgyduck/burke-ceg3120:latest`
     - Running with the -it tag is best for testing the image, as it enables the interactive container.
     - Running with a -d tag instead of -it is best for post-testing, as it runs in a detached state.
   - Validating if the angular application is working:
     - Validating from container side:
       - Run `docker logs <container_id>`
     - Validating from Host side:
       - Run `curl http://localhost:4200` and if there is an HTML output, it should be working.
     - Validating from External Connection:
       - Open an internet browser and type `http://52.91.191.210:4200` in the search bar, if it loads then it works!
   - Refreshing a new version of the Docker image:
     - Run `docker pull edgyduck/burke-ceg3120:latest` to pull the latest version.
     - Remove the current running container by running:
       ```
       docker ps
       docker stop <container_id>
       docker rm <container_id>
       ```
     - Start the container again `docker run -it --rm -p 4200:4200 edgyduck/burke-ceg3120:latest` (Or use the -d tag instead if no debugging necessary)
4. Application Refresh Bash Script
   - Testing the script:
     - Be sure Docker is running on the instance
     - Run the script (assuming you are in the Project5 folder)`./deployment/bash-deploy.sh`
     - Make sure the previous container is stopped and removed by using `docker ps -a`
     - Make sure the angular application is properly running by going to an internet browser and going to `http://52.91.191.210:4200`
   - Link to deployment script: [Script Link](https://github.com/WSU-kduncan/ceg3120-cicd-Brennnan12883/blob/main/Project5/deployment/bash-deploy.sh)
5. Webhook Listener Configuration
   - Installing adnanh's webhook:
     - First you must make sure to install Go.
       - Run the command `wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz ` to download version 1.24.2 of Go
       - Run the command `sudo tar -C /usr/local -xvzf go1.24.2.linux-amd64.tar.gz` to extract the contents of the install into `/usr/local`
       - Then you must go to your .bashrc file and add the following line at the bottom of the file:
         ```
         export PATH=$PATH:/usr/local/go/bin
         export GOPATH=$HOME/go
         export GOROOT=/usr/local/go
         ```
       - Once this is complete, run `source .bashrc` to set the changes in place.
       - Finally, run `go version` to see if Go successfully installed. If you see a version pop up, then it was a success.
       - Make sure you are on a version 1.21 or higher in Go as stated in the installation directions in adnanh's webhook.
   - Downloading Webhook
       - If Go is installed correctly, run `sudo apt-get install webhook`
       - Once this is finished, run `webhook --version` to test if it is properly installed.
   - Summary of Webhook file:
     - "id": The identifier for the webhook file, in this case it is "container-deployment"
     - "execute-command": The command to run when the webhook is triggered, which then points to the bash deployment script (~/ceg3120-cicd-Brennnan12883/Project5/deployment/bash-deploy.sh).
     - "command-working-directory": Working directory where the command should be executed.
     - "response-message": The return message once the webhook is successfully triggered.
     - "trigger-rule": Defines the conditions necessary to trigger a webhook, which is through "secrets" in this file.
   - Verifying Definition File is loaded:
     - Run the command `webhook -hooks ~/ceg3120-cicd-Brennnan12883/Project5/deployment/webhooks.json -verbose` and it will run with the verbose tag, then wait for payloads.
   - Checking logs of the Webhook
     - In order to monitor the logs of the webhook, and to check if a payload is being received, run `webhook -hooks ~/ceg3120-cicd-Brennnan12883/Project5/deployment/webhooks.json -verbose`
     - To monitor the logs from a currently running webhook, run `sudo journalctl -u webhook --follow`
     - What to look for in the docker process (`docker ps`)
       - After running `docker logs <container_id>` you want to look for any logs referencing incoming requests, hook extractions, and errors.
   - Link to Definition File:
       - [Definition File](https://github.com/WSU-kduncan/ceg3120-cicd-Brennnan12883/blob/main/Project5/deployment/webhooks.json)
6. Payload Sender Configuration
   - Selected GitHub as my payload sender, as I find it to be more accessible and I have more experience with GitHub. Also, it allows the payload to trigger from pushes and pulls.
   - Enabling the GitHub selection:
     - In the GitHub repository, go to Settings --> Webhooks then click add webhook.
     - Under Payload URL, enter `http://18.234.194.225:9000/hooks/container-deployment`
     - Push and Pull events will both trigger the Payload.
   - To verify that a payload was successfully sent, there should be a green checkmark in webhook deliveries inside of GitHub. Also, the command `sudo journalctl -u webhook --follow` can be ran inside of the EC2 instance       to check the webhook logs.
7. Configuring a Webhook Service for the EC2 Instance
   - Summary of the service file contents:
     - Description: Names the service and makes sure that it launches once the network comes online.
     - ExecStart: Command that runs the webhook listener, points to the webhooks.json file.
     - Restart: Automatically restarts the service if it fails.
     - User: Sets the service to run as the ubuntu user.
     - WorkingDirectory: Sets the default working directory where the service will run.
   - Enabling and starting the service:
     - Once the service file is created, run `sudo systemctl daemon-reload` to reload the system so that it will recognize the new service file.
     - Run `sudo systemctl enable webhook` so that the service will start automatically once the instance is online.
     - Run `sudo systemctl start webhook` to start the webhook now, without having to reboot the instance.
   - Checking if the service is working:
     - Run `sudo journalctl -u webhook --follow` to view the webhook service logs.
   - Link to service file:
     - [Service File](https://github.com/WSU-kduncan/ceg3120-cicd-Brennnan12883/blob/main/Project5/deployment/webhook.service)

## Part 3

## Part 4

## Resources

ChatGPT: Used ChatGPT with the prompt "Can you generate a github workflow that adheres to these guidelines: (Copy pasted the guidelines given)" and was given a proper workflow file template that I edited to fit my needs.
ChatGPT: Used the phrase, "I need to install Go to be able to install webhooks, how do I do this with version 1.24.2 of Go?"
https://github.com/adnanh/webhook 
