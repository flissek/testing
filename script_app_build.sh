#!/bin/bash
#Script is made to create docker image based on VUE app and push it to repository giving app version tag

#Ask for app tag
read -p "Write app version 
" ver

#create empty Dockerfile
touch Dockerfile

#Input building text to Dockerfile
echo "
FROM node:lts-alpine

# install simple http server for serving static content
RUN npm install -g http-server

# make the 'app' folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# install project dependencies
RUN npm install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# build app for production with minification
RUN npm run build

EXPOSE 8080

" > Dockerfile

#Build docker image based on given version number
docker build --tag flissek/testing:$ver .

#Ask for login and user password for the repository (at the moment login is hardcoded)
#read -p "Type your DockerHub login and press enter
#" user_name
read -s -p "Type your DockerHub pass and press enter
" user_pass

#alternate repository login
#docker login https://registry.com -u $((user_name)) -p $((user_pass))

#Dockerhub repository login
docker login -u flissek -p $user_pass
#Push created image to repository
sudo docker push flissek/testing:$ver
