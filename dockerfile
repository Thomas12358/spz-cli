FROM ubuntu:22.04

# Install system tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    libz-dev

# Set working directory
WORKDIR /app

# Copy source code
COPY . .

# Build the project
RUN mkdir build-linux && cd build-linux && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . --config Release

# Set entrypoint to the built executable
ENTRYPOINT ["/app/build-linux/spzcli"]
