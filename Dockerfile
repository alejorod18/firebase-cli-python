FROM node:lts-slim

ARG USER_HOME_DIR="/tmp"
ARG APP_DIR="/app"
ARG USER_ID=1000

ENV NPM_CONFIG_LOGLEVEL=warn NG_CLI_ANALYTICS=false

ENV HOME "$USER_HOME_DIR"

WORKDIR $APP_DIR
EXPOSE 4200

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

RUN apt-get update && apt-get upgrade && apt-get install -qqy --no-install-recommends \
    ca-certificates \
    dumb-init \
    git \
    build-essential \
    python \
    procps \
    rsync \
    curl \
    zip \
    openssh-client \
    wget \
    build-essential \
    checkinstall \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    libffi-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /usr/src \
    && wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz \
    && tar xzf Python-3.7.9.tgz \
    && rm -f Python-3.7.9.tgz \
    && cd Python-3.7.9 \
    && ./configure --enable-optimizations \
    && make install



RUN set -xe \
    && mkdir -p $USER_HOME_DIR \
    && chown $USER_ID $USER_HOME_DIR \
    && chmod a+rw $USER_HOME_DIR \
    && mkdir -p $APP_DIR \
    && chown $USER_ID $APP_DIR \
    && chown -R node /usr/local/lib /usr/local/include /usr/local/share /usr/local/bin \
    && (cd "$USER_HOME_DIR"; su node -c "npm install -g firebase-tools; npm cache clean --force")

USER $USER_ID