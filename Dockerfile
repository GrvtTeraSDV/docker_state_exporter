# -------- build stage -------------------------------------------------
    FROM golang:1.22-alpine AS builder
    WORKDIR /app
    
    # outils de base
    RUN apk add --no-cache git ca-certificates
    
    # pré‑copie des deps pour profiter du cache
    COPY go.mod go.sum ./
    RUN go mod download
    
    # puis le reste du code
    COPY . .
    
    # build statique
    RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o docker_state_exporter .
    
    # -------- runtime stage ----------------------------------------------
    FROM alpine:3.18
    COPY --from=builder /app/docker_state_exporter /usr/local/bin/docker_state_exporter
    
    EXPOSE 8080
    ENTRYPOINT ["/usr/local/bin/docker_state_exporter"]
    CMD ["-listen-address=:8080"]
    