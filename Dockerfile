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

# Install Node.js (includes npm) - using LTS version
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install TypeScript and Angular CLI globally
RUN npm install -g typescript @angular/cli

# Install Rust using rustup (as non-root to avoid permission issues)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install common Rust tools
RUN /root/.cargo/bin/rustup component add rustfmt clippy

# Install additional development tools
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for development
RUN useradd -m developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the developer user
USER developer
WORKDIR /home/developer

# Set up environment variables for the developer user
ENV PATH="/home/developer/.cargo/bin:${PATH}"

# Verify installations in a way that won't break the build
RUN bash -c "command -v rustc && command -v cargo && command -v node && command -v npm && command -v tsc && command -v ng"

# Default command when container starts
CMD ["/bin/bash"]
