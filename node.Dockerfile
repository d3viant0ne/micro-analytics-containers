FROM ubuntu:xenial

MAINTAINER Webpack

# Setup Build ENV
# ...
ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 8.9.0
ENV NPM_VERSION=5

# Configure Install Environment
# ...
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Run updates and install deps
# ...
RUN apt-get update --fix-missing

# Install needed deps and clean up after
RUN apt-get install -y -q --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    libssl-dev \
    curl \
    g++ \
    gcc \
    git \
    make \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y autoclean

# NodeJS Configuration
# ...
ENV NVM_DIR /usr/local/nvm

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Set up our PATH correctly so we don't have to long-reference npm, node, &c.
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install Global Node Libs
# ...
RUN npm i -g pm2
RUN npm i -g micro-analytics-cli
RUN npm i micro-analytics-adapter-mongodb

ENV MAA_MONGODB_URL="mongodb://mongodb:27017/analyticsdb"
ENV DB_ADAPTER=mongodb

EXPOSE 3000

CMD ["pm2-docker", "start", "--auto-exit", "micro-analytics"]