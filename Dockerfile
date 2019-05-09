FROM golang:1.11.6-alpine3.9 AS builder

# For debugging: get Delve
RUN apk add --no-cache git
RUN go get github.com/derekparker/delve/cmd/dlv

# Copy Code and build it:
WORKDIR $GOPATH/src/github.com/joe15000/vscode_go_debug/
COPY . ./

# Build App 1 - Extra Flags for Delve
RUN CGO_ENABLED=0 GOOS=linux go build -gcflags "all=-N -l" -a -installsuffix nocgo -o /app1 ./cmd/app1

# Create a lightweight container and copy the compiled app into it
FROM alpine:3.9 AS runtime-base

# DEBUGGING: Allow delve to run on Alpine based containers.
RUN apk add --no-cache libc6-compat

# Final runtime container with app and Delve
FROM runtime-base

WORKDIR /
# Copy certificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# Copy app
COPY --from=builder /app1 ./
# Copy delve
COPY --from=builder /go/bin/dlv /

# 40000 for delve
EXPOSE 30000

# Start headless Delve server, launching the app, listening on port 40000
CMD ["/dlv","--listen=:30000","--headless=true","--api-version=2", "exec", "./app1"]
