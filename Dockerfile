# Multi stage build: builder
FROM golang:1.18 as builder
WORKDIR /workspace
COPY . .
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o /app ./main.go


# Multi stage build: production
FROM gcr.io/distroless/static-debian11 as production
COPY --from=builder /app /app
ENV GODEBUG netdns=go
ENTRYPOINT ["/app"]