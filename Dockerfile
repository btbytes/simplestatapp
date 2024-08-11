FROM nimlang/nim:latest AS baseimage

RUN apt-get update && apt-get install -y \
    libssl-dev libpcre3-dev libsqlite3-dev\
    && rm -rf /var/lib/apt/lists/*

FROM baseimage AS builder
WORKDIR /app
COPY simplestatapp.nimble .
RUN nimble install -y --depsOnly
WORKDIR /app
COPY . .
RUN nimble build --verbose

FROM scratch
COPY --from=builder /app/app /app
COPY --from=builder /app/students.db /students.db
COPY --from=builder /app/README.md /README.md

ENTRYPOINT ["/app"]
