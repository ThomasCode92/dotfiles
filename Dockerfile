FROM ubuntu:latest

# update package list and install some basic utilities
RUN apt-get update && apt-get install -y \
  curl

# set a working directory
WORKDIR /app

# default command
CMD [ "/bin/bash" ]
