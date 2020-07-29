FROM golang:1.14.6-buster AS build

WORKDIR /src

RUN useradd appuser

ENV AWS_REGION="us-east-1"

EXPOSE 8000

COPY go.mod go.sum main.go ./

RUN env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app && \
    chown appuser:appuser app

USER appuser

ENTRYPOINT ./app