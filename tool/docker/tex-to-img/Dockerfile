FROM ubuntu:20.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        pdf2svg \
        texlive-latex-base \
        texlive-latex-extra \
 && true

COPY tex-to-img /bin
