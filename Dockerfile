FROM nimlang/nim:latest AS builder

RUN apt-get update && apt-get install -y \
    libssl-dev libpcre3-dev libsqlite3-dev\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY simplestatapp.nimble .
RUN nimble install -y --depsOnly
WORKDIR /app
COPY . .

# Compile the application
RUN nim c -d:release --opt:size -d:nimDebugDlOpen \
    --passC:"-fPIC -pie -O3" \
    --passL:"-fPIC -pie -O3" \
    --passL:/usr/lib/x86_64-linux-gnu/libpcre32.a \
    --passL:/usr/lib/x86_64-linux-gnu/libsqlite3.a \
    --dynlibOverride:pcre \
    --dynlibOverride:sqlite3 \
    --passL:"-static -lm -lpcre -lsqlite3 " app.nim

FROM scratch
COPY --from=builder /app/app /app
COPY --from=builder /app/students.db /students.db
COPY --from=builder /app/README.md /README.md

ENTRYPOINT ["/app"]
