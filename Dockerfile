# Use Ubuntu as the base image
FROM ubuntu:latest

# Install necessary packages and dependencies
RUN apt update && apt install -y \
    curl wget sudo git build-essential cmake libjson-c-dev libwebsockets-dev

# Create a non-root user for safer terminal access
RUN useradd -ms /bin/bash ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install ttyd (web-based terminal)
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && make && make install

# Switch to the new user
USER ubuntu
WORKDIR /home/ubuntu

# Start ttyd on port 7681 with bash shell
CMD ["ttyd", "-p", "7681", "bash"]

