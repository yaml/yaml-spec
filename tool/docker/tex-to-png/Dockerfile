FROM ubuntu:20.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        poppler-utils \
        texlive-latex-base \
 && true

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        texlive-latex-extra \
 && true

COPY tex-to-png /bin
