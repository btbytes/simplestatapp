FROM nimlang/nim:latest AS builder

ENV DEBIAN_FRONTEND=noninteractive

# we install the latest gcc
# so that we can have better PIE experience
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y gcc-11 g++-11 libssl-dev libpcre3-dev libsqlite3-dev \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-11 \
    --slave /usr/bin/gcov gcov /usr/bin/gcov-11 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY simplestatapp.nimble .
RUN nimble install -y --depsOnly
WORKDIR /app
COPY . .

RUN nimble build

FROM scratch
COPY --from=builder /app/app /app
COPY --from=builder /app/students.db /students.db
COPY --from=builder /app/README.md /README.md

ENTRYPOINT ["/app"]
