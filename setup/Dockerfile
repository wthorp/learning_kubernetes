# This image serves two purposes:  
# A multi-stage base image and to setup configs

# Keep this image up to date from list at https://hub.docker.com/_/golang
FROM golang:1.12.9-alpine3.10 AS build
#create a custom user to further restrict priviledges
RUN addgroup -g 65530 storj
RUN adduser -D -G storj storj -u 65530
#cache (and cache bust) go dependencies
WORKDIR /storj
ADD https://raw.githubusercontent.com/storj/storj/master/go.mod go.mod
RUN /sbin/apk --no-cache add git
RUN go mod download
#download the storj satellite code, using ADD prevents the need to cache bust git clone
ADD https://github.com/storj/storj/tarball/master storj.tar.gz
RUN tar -xzf storj.tar.gz --strip 1 && rm storj.tar.gz
#statically compile Go using CGO and MUSL, so that even the C libararies are statically linked
RUN /sbin/apk --no-cache add gcc musl-dev
RUN CC=/usr/bin/x86_64-alpine-linux-musl-gcc go build --ldflags '-linkmode external -extldflags "-static"'  -o /satellite ./cmd/satellite
#compile identity normally
RUN go build -o /identity ./cmd/identity
#this does nothing?
#RUN mkdir -p /root/.local/share/storj
#VOLUME /root/.local/storj
#use storj user for runs
USER storj:storj