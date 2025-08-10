# Start with an official Ubuntu base image
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic utilities and curl
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    wget \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (includes npm) locally for the developer user
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install TypeScript and Angular CLI globally but within the developer user's environment
RUN npm install -g typescript @angular/cli

# Create a non-root user for development
RUN useradd -m developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the developer user
USER developer
WORKDIR /home/developer

# Install Rust using rustup (as the developer user)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Ensure the PATH is set to include cargo and rustup binaries for the developer user
ENV PATH="/home/developer/.cargo/bin:${PATH}"

# Verify Rust and Cargo installation (check if rustc and cargo are available)
# RUN command -v rustc && command -v cargo && command -v node && command -v npm && command -v tsc && command -v ng

# Default command when container starts
# CMD ["/bin/bash"]

