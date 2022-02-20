
# release base
FROM golang:1.17-alpine as builder-base
RUN apk update
RUN apk add build-base
# install dependency here

# builder
FROM builder-base AS builder
RUN mkdir /build
COPY . /build/
WORKDIR /build
RUN go mod download
RUN GOOS=linux GOARCH=386 CGO_ENABLED=0 go build -ldflags="-w -s" -o /build/pofwd

# release 
FROM scratch AS release
WORKDIR /go/bin
COPY --from=builder /build/pofwd /go/bin/pofwd
ENTRYPOINT [ "/go/bin/pofwd" ]