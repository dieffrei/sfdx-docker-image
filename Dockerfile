FROM alpine:3.9
MAINTAINER Dieffrei T. Quadros <dieffrei.quadros@globalinter.net>

# Add packages
RUN apk --no-cache add \
    bash \
    openssh \
    git \
    openjdk8 \
    nodejs \
    npm \
    curl \
    wget \
    unzip \
    nss \
    jq \
    libsecret \
    chromium \
    && apk add apache-ant --no-cache --update-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
    --allow-untrusted

# Copy build files
COPY build /build/

# Install SFDX
RUN npm install sfdx-cli --global
RUN sfdx --version
RUN sfdx plugins --core
RUN echo 'y' | sfdx plugins:install texei-sfdx-plugin
RUN echo 'y' | sfdx plugins:install sfdx-codescan-plugin
RUN echo 'y' | sfdx plugins:install json-bourne-sfdx
RUN echo 'y' | sfdx plugins:install gin-sfdx-plugin
RUN sfdx plugins

# Setup entry point to use umask 0000 and run bash
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
# EOF
