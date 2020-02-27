FROM alpine:edge
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
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    yarn    

# Install SFDX
RUN npm install sfdx-cli --global
RUN sfdx --version
RUN sfdx plugins --core
RUN echo 'y' | sfdx plugins:install texei-sfdx-plugin
RUN echo 'y' | sfdx plugins:install sfdx-codescan-plugin
RUN echo 'y' | sfdx plugins:install json-bourne-sfdx
RUN echo 'y' | sfdx plugins:install gin-sfdx-plugin
RUN sfdx plugins

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Puppeteer v1.19.0 works with Chromium 77.
RUN yarn add puppeteer@1.19.0

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app

# Copy build files
#COPY build /build/

# Setup entry point to use umask 0000 and run bash
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
# EOF

# Run everything after as non-privileged user.
#USER pptruser
