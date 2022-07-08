FROM golang:latest AS builder
WORKDIR /
ADD main.go /
RUN CGO_ENABLED=0 go build -o app main.go

FROM alpine:latest
COPY --from=builder app ./
CMD ["./app"]
