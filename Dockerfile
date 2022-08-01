
# release base
FROM --platform=$BUILDPLATFORM golang:1.18-alpine as builder-base
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG BUILDARCH
RUN apk update
RUN apk add build-base
# install dependency here

# builder
FROM builder-base AS builder
RUN mkdir /build
COPY . /build/
WORKDIR /build
RUN go mod download
RUN GOOS=linux GOARCH=${BUILDARCH} CGO_ENABLED=0 go build -ldflags="-w -s" -o /build/pofwd

# release 
FROM scratch AS release
WORKDIR /
COPY --from=builder /build/pofwd /usr/bin/pofwd
CMD [ "pofwd", "/pofwd.conf"]
