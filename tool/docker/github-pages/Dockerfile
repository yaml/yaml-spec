FROM jekyll/jekyll:latest

COPY Gemfile /tmp/

WORKDIR /tmp

RUN bundle install

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN apk add \
    coreutils \
    vim \
 && true

COPY run /usr/bin

WORKDIR /
