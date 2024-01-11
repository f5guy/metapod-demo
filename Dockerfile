FROM golang:1.21.0 as build
WORKDIR /opt
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o metapod

FROM alpine:3.18.3

RUN adduser -D -u 2025 metapod
WORKDIR /home/metapod

COPY --from=build /opt/metapod /home/metapod/metapod

ADD templates /home/metapod/templates
ADD static /home/metapod/static

RUN chmod +x metapod

USER 2025
EXPOSE 3333

ENTRYPOINT ["./metapod"]
