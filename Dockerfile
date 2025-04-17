# -------- build stage -------------------------------------------------
FROM golang:1.23-alpine AS builder   # ← nouvelle version
WORKDIR /app
    
RUN apk add --no-cache git ca-certificates
    
COPY go.mod go.sum ./
RUN go mod download
    
COPY . .
    
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o docker_state_exporter .
    
# -------- runtime stage ----------------------------------------------
FROM alpine:3.18
COPY --from=builder /app/docker_state_exporter /usr/local/bin/docker_state_exporter
    
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/docker_state_exporter"]
CMD ["-listen-address=:8080"]
    