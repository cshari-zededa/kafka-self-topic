FROM golang:alpine AS build
RUN apk --no-cache add gcc g++ make git
WORKDIR /go/src/app
COPY . .
RUN go mod init kafka_app 
RUN go mod tidy
RUN GOOS=linux go build -tags musl -ldflags="-s -w" -o ./bin/kafka_app ./kafka_app.go

FROM alpine:3.13
RUN apk --no-cache add ca-certificates
WORKDIR /usr/bin
COPY --from=build /go/src/app/bin /go/bin
EXPOSE 80
ENTRYPOINT /go/bin/kafka_app
