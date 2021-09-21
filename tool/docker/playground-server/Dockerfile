FROM yamlio/yaml-editor

RUN sed -i -e 's/v3\.10/v3.12/g' /etc/apk/repositories

RUN apk update

RUN apk add \
        bash \
        build-base \
        cargo=1.44.0-r0 \
        curl \
        git \
        libffi-dev \
        m4 \
        musl-dev \
        openssl-dev \
        perl \
        perl-app-cpanminus \
        perl-dev \
        py3-pip \
        python3 \
        python3-dev \
        vim \
        wget \
 && true

RUN pip3 install \
        flask \
        flask-cors \
        pyopenssl \
        pyyaml \
 && true

# This hack is to keep the Haskell reference parser working:
RUN cd /usr/lib \
 && ln -s libffi.so.7.1.0 libffi.so.6 \
 && true

COPY ./bin/ /bin/

ENTRYPOINT ["playground-sandbox"]
