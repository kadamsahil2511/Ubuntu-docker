# Use Ubuntu as the base image
FROM ubuntu:latest

# Install necessary packages and dependencies and clean up apt cache
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    git \
    build-essential \
    cmake \
    libjson-c-dev \
    libwebsockets-dev \
    && rm -rf /var/lib/apt/lists/*

# The 'ubuntu' user already exists in the base image.
# Grant passwordless sudo privileges to the existing 'ubuntu' user.
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install ttyd (web-based terminal)
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd / && \
    rm -rf /ttyd

# Switch to the ubuntu user
USER ubuntu
WORKDIR /home/ubuntu

# Expose the port ttyd will run on
EXPOSE 7681

# Start ttyd on port 7681 with bash shell
CMD ["ttyd", "-p", "7681", "--writable", "bash"]
