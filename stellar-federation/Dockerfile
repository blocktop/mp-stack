FROM golang:1.12 as build

RUN go get -u github.com/stellar/go/services/federation


FROM stellar-base

COPY --from=build /go/bin/federation /usr/bin/stellar-federation
COPY . .

CMD ["/start.sh"]