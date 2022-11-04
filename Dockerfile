################ Build & Dev ################
# Build stage will be used:
# - for building the application for production
FROM golang:1.19.2-alpine as build

# Create project directory (workdir)
WORKDIR /app

# Add source code files to WORKDIR
ADD . .

# Build application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .

# Container start command for development
CMD ["go", "run", "main.go"]


################ Production ################
# Creates a minimal image for production using distroless base image
# More info here: https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/base-debian10 as production

# Copy application binary from build/dev stage to the distroless container
COPY --from=build /app/main /

# Application port (optional)
EXPOSE 8080

# Container start command for production
CMD ["/main"]
