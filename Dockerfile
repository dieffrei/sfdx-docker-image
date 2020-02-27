FROM salesforce/salesforcedx
MAINTAINER Dieffrei T. Quadros <dieffrei.quadros@globalinter.net>

RUN echo 'y' | sfdx plugins:install texei-sfdx-plugin
RUN echo 'y' | sfdx plugins:install sfdx-codescan-plugin
RUN echo 'y' | sfdx plugins:install json-bourne-sfdx
RUN echo 'y' | sfdx plugins:install gin-sfdx-plugin

ENV SFDX_CONTAINER_MODE true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash
