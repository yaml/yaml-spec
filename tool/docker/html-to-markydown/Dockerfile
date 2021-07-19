FROM ubuntu:20.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        build-essential \
        nodejs \
        npm \
 && true

RUN mkdir /node_modules \
 && cd / \
 && npm install -g coffeescript \
 && npm install \
        domino \
        ingy-prelude \
        turndown \
        turndown-plugin-gfm \
        smartwrap \
 && true

COPY html-to-markydown /bin

RUN apt-get install -y \
        git \
        silversearcher-ag \
        tig \
        tmux \
        vim \
 && true
