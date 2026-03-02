# Use the official Swift image for Linux
FROM swift:6.2-noble

# Install required dependencies for Swift packages
RUN apt-get update && apt-get install -y \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY Package.swift Package.resolved ./

# Copy source code
COPY Sources ./Sources
COPY Tests ./Tests

# Try to build the package (both library and executable)
RUN swift build --target ApplePackage 2>&1 || echo "Library build failed as expected"
RUN swift build --target ApplePackageTool 2>&1 || echo "Executable build failed as expected"

# Default command
CMD ["swift", "build"]
