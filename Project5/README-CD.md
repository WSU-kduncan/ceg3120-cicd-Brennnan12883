# Project 5
Written By: Brennan Burke

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
     - 

## Resources

ChatGPT: Used ChatGPT with the prompt "Can you generate a github workflow that adheres to these guidelines: (Copy pasted the guidelines given)" and was given a proper workflow file template that I edited.
