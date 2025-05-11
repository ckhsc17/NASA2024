FROM alpine:latest

RUN apk add --no-cache sl

CMD ["sl"]