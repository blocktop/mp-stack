FROM debian:10-slim

ADD https://raw.githubusercontent.com/guilhem/apt-get-install/master/apt-get-install /usr/bin/
RUN chmod +x /usr/bin/apt-get-install \
    && set -ex \
    && apt-get update && apt-get install -y wget gnupg2 apt-transport-https ca-certificates sudo \
    && gpg --keyserver keys2.kfwebs.net --recv-keys A136B5A6 \
    && wget -qO - https://apt.stellar.org/SDF.asc | apt-key add - \
    && echo "deb https://apt.stellar.org/public stable/" | tee -a /etc/apt/sources.list.d/SDF.list \
    && wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | tee -a /etc/apt/sources.list.d/pgdg.list \
    && apt-get-install postgresql-client-11 \
    && useradd -ms /bin/bash -G sudo stellar

COPY ./etc/sudoers.d/* /etc/sudoers.d/

USER stellar

