FROM stellar-base

ARG COMPLIANCE_VERSION=0.0.32

RUN cd ~ \
    && wget -q https://github.com/stellar/go/releases/download/compliance-v${COMPLIANCE_VERSION}/compliance-v${COMPLIANCE_VERSION}-linux-amd64.tar.gz \
    && tar -xf compliance-v${COMPLIANCE_VERSION}-linux-amd64.tar.gz \
    && sudo cp -v compliance-v${COMPLIANCE_VERSION}-linux-amd64/compliance /usr/bin/stellar-compliance \
    && rm -rf compliance-v${COMPLIANCE_VERSION}-linux-amd64

COPY . .

ENTRYPOINT ["/start.sh"]
