FROM ubuntu:20.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        build-essential \
        cpanminus \
 && true

RUN cpanm -n YAML::PP XXX

COPY markydown-to-kramdown /bin

RUN apt-get install -y git silversearcher-ag tig tmux vim
