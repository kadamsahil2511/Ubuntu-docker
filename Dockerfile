# ====================================================================================
#  WARNING: INSECURE - FOR EDUCATIONAL & ISOLATED TESTING PURPOSES ONLY
#  Setting a password in a Dockerfile is a major security risk. The password is
#  stored in plain text in the image layers and is easily exposed.
#  DO NOT USE THIS IN A PRODUCTION ENVIRONMENT.
# ====================================================================================

# Use Ubuntu as the base image
FROM ubuntu:latest

# Set a non-interactive frontend for package installation to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set the root password (INSECURE PRACTICE)
# Replace 'your_insecure_password' with the password you want to set for the root user.
RUN echo 'root:your_insecure_password' | chpasswd

# Install necessary packages, create the 'ubuntu' user, and grant passwordless sudo
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    git \
    build-essential \
    cmake \
    libjson-c-dev \
    libwebsockets-dev \
    && rm -rf /var/lib/apt/lists/* \
    # Create a new non-root user named 'ubuntu' with a home directory
    && useradd -m -s /bin/bash ubuntu \
    # Add the 'ubuntu' user to the 'sudo' group for passwordless sudo access
    && adduser ubuntu sudo \
    # This line ensures that any member of the sudo group can use sudo without a password
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install ttyd (web-based terminal)
# This is run as root before switching to the 'ubuntu' user
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd / && \
    rm -rf /ttyd

# Switch to the non-root 'ubuntu' user for runtime
USER ubuntu
WORKDIR /home/ubuntu

# Expose the port ttyd will run on
EXPOSE 7681

# Start ttyd on port 7681 with a bash shell as the 'ubuntu' user
CMD ["ttyd", "-p", "7681", "--writable", "bash"]
