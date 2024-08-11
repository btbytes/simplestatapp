# Stage 1: Build the Nim application
FROM nimlang/nim:latest AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev libpcre3-dev libsqlite3-dev\
    && rm -rf /var/lib/apt/lists/*

# Install Prologue
RUN nimble install -y prologue db_connector

# Set the working directory
WORKDIR /app

# Copy the source code
COPY app.nim .
COPY students.db .

# Compile the application
RUN nim c -d:release --opt:size -d:nimDebugDlOpen --dynlibOverride:sqlite3 --passL:/usr/lib/x86_64-linux-gnu/libsqlite3.a --passL:"-static -lsqlite3 -lm" app.nim

# Stage 2: Create the final image
FROM scratch
# Copy the compiled binary from the builder stage
COPY --from=builder /app/app /app
COPY --from=builder /app/students.db /students.db

# FROM builder AS original
# FROM ubuntu:latest
# COPY --from=original /app/app /app/app
# RUN apt-get update && apt-get install -y libc-bin
# CMD ldd /app/app

# Set the entrypoint
ENTRYPOINT ["/app"]
