FROM node:20-slim

# Install required packages
RUN apt-get update && \
    apt-get install -y git ca-certificates curl unzip && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates

# Set working directory
WORKDIR /app

# Download Developer Portal repo at tag 2.27.0
RUN curl -L -k https://github.com/Azure/api-management-developer-portal/archive/refs/tags/2.27.0.zip -o portal.zip && \
    unzip portal.zip && \
    mv api-management-developer-portal-2.27.0/* . && \
    find api-management-developer-portal-2.27.0 -maxdepth 1 -name '.*' ! -name '.' ! -name '..' -exec mv {} . \; && \
    rm -rf api-management-developer-portal-2.27.0 portal.zip

# Copy your template config files into the container
# (assumes these are in the same directory as the Dockerfile)
COPY config.*.template.json ./
COPY generate-configs.js ./

# Install dependencies once
RUN npm install

# Expose runtime port
ENV PORT=8080

# Default command: generate config, build portal, and serve it
CMD ["sh", "-c", "\
  node generate-configs.js && \
  npm run publish"]