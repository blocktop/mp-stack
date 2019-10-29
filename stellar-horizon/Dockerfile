FROM stellar-base

RUN sudo apt-get-install stellar-horizon

COPY . .

USER stellar

ENTRYPOINT ["/start.sh"]