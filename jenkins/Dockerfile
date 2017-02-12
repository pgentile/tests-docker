FROM jenkins

USER root

# Extra build tools
RUN echo 'Install build tools' \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo 'deb https://deb.nodesource.com/node_7.x jessie main' > /etc/apt/sources.list.d/nodesource.list \
    && echo 'deb-src https://deb.nodesource.com/node_7.x jessie main' >> /etc/apt/sources.list.d/nodesource.list \
    && echo 'deb https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y build-essential nodejs yarn

USER jenkins

# Jenkins config
COPY ./config/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

# Install plugins
RUN /usr/local/bin/install-plugins.sh workflow-aggregator pipeline-utility-steps git junit
