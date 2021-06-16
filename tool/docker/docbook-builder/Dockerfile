FROM ubuntu:20.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        build-essential \
        default-jre \
        docbook-xsl \
        ghostscript \
        libexpat1-dev \
        libxml-parser-perl \
        libyaml-perl \
        xsltproc \
 && true

RUN apt-get install -y \
        git \
        silversearcher-ag \
        tig \
        tmux \
        vim \
 && true
