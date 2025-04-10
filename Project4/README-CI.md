# Project 3
Written By: Brennan Burke
## Part 1
1. Setting up Docker
    - Visit the Docker website and click "Download Docker Desktop". https://www.docker.com/get-started/
    - Once installed, open Docker Desktop, sign in, then go to settings. Go to the resources tab, then the WSL integration tab. Make sure "Enable integration with my default WSL distro" is checked. (You can also Enable             integration with a distro that you use, such as Ubuntu)
    - Make sure WSL2 is installed on your system. This can be done by doing ` wsl -l -v ` then following up with `wsl --install` if it is not installed.
    - Make sure Docker is installed correctly by using the command `docker --version` then doing a test command such as `docker run hello-world`.
2. Setting up a container
   - Run the docker container command, it should look something like this `docker run -it --rm -p 4200:4200 -v $(pwd)/angular-site/wsu-hw-ng-main:/usr/src/app -w /usr/src/app node:18-bullseye bash` The pathway might differ slightly but it should look roughly the same.
       - Using the tag `-it` makes the terminal interactable after running.
       - `--rm` will make the container remove itself after exiting.
       - `-p 4200:4200` maps port 4200 on the container to port 4200 on the local host.
       - `-v $(pwd)/angular-site/wsu-hw-ng-main:/usr/src/app` will mount the container from the host device to the container.
       - `-w /usr/src/app` will place the angular-site directory inside of the `/usr/src/app` directory.
       - `bash` will run the bash shell inside of the container.
    - Command used for dependencies installed inside of the container:
          - `npm install -g @angular/cli`
    - Command used to run the application inside of the container:
          - `ng serve --host 0.0.0.0`
    - Validating the container is properly hosting:
          - From the container side, run `docker logs <container_id>` for example my container id was b03eb93e3d0c, so I would run `docker logs b03eb93e3d0c`
          - From the local host side, go to your browser and open the link `http://localhost:4200`, if "Birds gone wild" appears, then it has properly connected.

3. Utilizing Dockerfile and Images
   - Dockerfile explanation:
         - FROM node:18-bullseye: Uses the Node.js base image.
         - WORKDIR /usr/src/app: Sets the working directory of angular-site inside the container to /user/src/app.
         - COPY . .: Copies the Angular app into the container.
         - RUN npm install -g @angular/cli: Installs all required dependencies needed for Angular.
         - CMD ["npm", "run", "start"] Runs the Angular app when the container starts.
   - How to build an image from the Dockerfile repository:
        - I ran the command `docker build -t edgyduck/burke-ceg3120:latest .`
   - How to run a container from this image:
        - I ran the command `docker run -it --rm -p 4200:4200 -v $(pwd)/angular-site/wsu-hw-ng-main:/usr/src/app -w /usr/src/app node:18-bullseye bash` to run a container.
   - Validating the container is properly hosting:
        - From the container side, run `docker logs <container_id>` for example my container id was b03eb93e3d0c, so I would run `docker logs b03eb93e3d0c`
        - From the local host side, go to your browser and open the link `http://localhost:4200`, if "Birds gone wild" appears, then it has properly connected.
     
4. Using the DockerHub Repository
   - How to create a public repository in Dockerhub:
        - Go to Dockerhub, then click "Create Repository", then name it <YOURLASTNAME>-CEG3120
   - How to authenticate login to Dockerhub:
        - Enter the command `docker login` and it should redirect you to Dockerhub, I actually had an error and had to manually copy and paste the given code into Dockerhub after pasting the link.
   - How to push your image onto Dockerhub:
        - Run `docker tag node:18-bullseye <yourusername>/<YOURLASTNAME>-CEG3120:latest` to tag the image.
        - Then run `docker push <yourusername>/<YOURLASTNAME>-CEG3120:latest`to push the image.
   - Link to my Dockerhub Repository:
        - https://hub.docker.com/repository/docker/edgyduck/burke-ceg3120/general

