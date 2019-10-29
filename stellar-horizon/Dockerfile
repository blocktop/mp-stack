FROM stellar-base

RUN sudo apt-get-install stellar-horizon

COPY . .

RUN set -ex \
    && sudo cp -v /rootCA.pem /usr/share/ca-certificates/ \
    && echo 1 | sudo dpkg-reconfigure --terse ca-certificates

USER stellar

