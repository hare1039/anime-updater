FROM golang:1-alpine AS builder
MAINTAINER hare1039@hare1039.nctu.me

RUN apk add --update git

RUN go get github.com/Jeffail/gabs     &&\
    go get github.com/gin-contrib/cors &&\
    go get github.com/gin-gonic/gin    &&\
    go get gopkg.in/mgo.v2             &&\
    go get gopkg.in/mgo.v2/bson

COPY anime-update-bot.go /tmp/anime-update-bot.go

RUN cd /tmp/ &&\
    go build

FROM alpine
MAINTAINER hare1039@hare1039.nctu.me

COPY --from=builder /tmp/tmp /tmp/anime-update-bot

VOLUME ["/bot-server"]

RUN chmod +x /tmp/anime-update-bot

WORKDIR /bot-server

EXPOSE 8027

ENTRYPOINT ["sh", "-c", "cd /bot-server; /tmp/anime-update-bot"]