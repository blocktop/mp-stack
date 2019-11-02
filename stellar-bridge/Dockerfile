FROM stellar-base

ARG BRIDGE_VERSION=0.0.32

RUN cd ~ \
    && wget -q https://github.com/stellar/go/releases/download/bridge-v${BRIDGE_VERSION}/bridge-v${BRIDGE_VERSION}-linux-amd64.tar.gz \
    && tar -xf bridge-v${BRIDGE_VERSION}-linux-amd64.tar.gz \
    && sudo cp -v bridge-v${BRIDGE_VERSION}-linux-amd64/bridge /usr/bin/stellar-bridge \
    && rm -rf bridge-v${BRIDGE_VERSION}-linux-amd64

COPY . .

ENTRYPOINT ["/start.sh"]
