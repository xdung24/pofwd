
# release base
FROM golang:1.17-alpine as release-base
RUN apk update
# install dependency here

# builder-base
FROM release-base as builder-base
RUN apk add build-base

# builder
FROM builder-base AS builder
RUN mkdir /build
ADD . /build/
WORKDIR /build
COPY go.mod ./
COPY go.sum ./
RUN go mod download
RUN go build -o /pofwd

# release 
FROM release-base AS release
WORKDIR /go/bin
COPY --from=builder /pofwd /go/bin/pofwd
ENTRYPOINT [ "/go/bin/pofwd" ]