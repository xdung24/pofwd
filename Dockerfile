
# release base
FROM golang:1.17-alpine as builder-base
RUN apk update
RUN apk add build-base
# install dependency here
# create ft user
ENV USER=ft
ENV UID=1000

# See https://stackoverflow.com/a/55757473/12429735RUN 
RUN adduser \    
    --disabled-password \    
    --gecos "" \    
    --home "/nonexistent" \    
    --shell "/sbin/nologin" \    
    --no-create-home \    
    --uid "${UID}" \    
    "${USER}"

# builder
FROM builder-base AS builder
RUN mkdir /build
COPY . /build/
WORKDIR /build
RUN go mod download
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s" -o /build/pofwd

# release 
FROM scratch AS release
WORKDIR /
COPY --from=builder /build/pofwd /usr/bin/pofwd
USER ft:ft
ENTRYPOINT [ "pofwd" ]
CMD [ "pofwd", "/pofwd.conf"]
