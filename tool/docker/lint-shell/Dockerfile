FROM ubuntu:20.04

RUN apt-get update \
 && apt-get install -y \
        apt-utils \
        wget \
        xz-utils \
 && wget https://github.com/koalaman/shellcheck/releases/download/v0.7.2/shellcheck-v0.7.2.linux.x86_64.tar.xz \
 && tar xf shellcheck-v0.7.2.linux.x86_64.tar.xz \
 && mv shellcheck-v0.7.2/shellcheck /usr/local/bin \
 && rm -fr shellcheck-v0.7.2* \
 && true

COPY lint-shell /usr/local/bin
