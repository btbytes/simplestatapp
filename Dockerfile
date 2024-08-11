FROM ubuntu:24.04 as baseimage

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and musl-gcc
RUN apt-get update && apt-get install -y \
    build-essential \
    musl-tools \
    libc6-dev \
    libpcre3-dev \
    libsqlite3-dev \
    musl-dev \
    apt-file \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN apt-file update


# Set up musl-gcc as the default compiler
ENV CC=musl-gcc

# Find package providing libm.a
RUN LIBM_PATH="/usr/lib/x86_64-linux-gnu/libm.a" && \
    if [ -f "$LIBM_PATH" ]; then \
    PACKAGE=$(dpkg -S "$LIBM_PATH" 2>/dev/null); \
    echo "The file $LIBM_PATH is provided by the package: $PACKAGE"; \
    else \
    PACKAGE=$(apt-file search "$LIBM_PATH" | head -n1); \
    if [ -n "$PACKAGE" ]; then \
    echo "The file $LIBM_PATH would be provided by the package: $PACKAGE"; \
    PACKAGE_NAME=$(echo $PACKAGE | cut -d: -f1); \
    apt-get update && apt-get install -y $PACKAGE_NAME; \
    else \
    echo "No package found that would provide $LIBM_PATH"; \
    fi; \
    fi

# Build and install a static version of PCRE
RUN curl -LO https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz \
    && tar xzf pcre-8.45.tar.gz \
    && cd pcre-8.45 \
    && CC=musl-gcc CFLAGS="-static" ./configure --disable-shared --enable-static \
    && make \
    && make install \
    && cd .. \
    && rm -rf pcre-8.45 pcre-8.45.tar.gz

# Build and install a static version of SQLite
RUN curl -LO https://www.sqlite.org/2024/sqlite-autoconf-3460000.tar.gz \
    && tar xzf sqlite-autoconf-3460000.tar.gz \
    && cd sqlite-autoconf-3460000 \
    && CC=musl-gcc CFLAGS="-static" ./configure --disable-shared --enable-static \
    && make \
    && make install \
    && cd .. \
    && rm -rf sqlite-autoconf-3460000 sqlite-autoconf-3460000.tar.gz

# Set the library path to include the newly built static libraries
ENV LD_LIBRARY_PATH=/usr/local/lib

RUN curl -LO https://nim-lang.org/download/nim-2.0.8.tar.xz \
    && tar -xf nim-2.0.8.tar.xz \
    && mv nim-2.0.8 nim \
    && cd nim \
    && sh build.sh \
    && bin/nim c koch \
    && ./koch tools \
    && cd ..

ENV PATH="/nim/bin:${PATH}"
ENV NIM_PARAMS="--passL:-static --passL:-no-pie --passL:-fno-lto"

# # Test stage
# FROM baseimage as test
# WORKDIR /test
# COPY test-script.sh .
# RUN chmod +x test-script.sh
# CMD ["/bin/bash"]

# builder stage
FROM baseimage AS builder
WORKDIR /app
COPY simplestatapp.nimble .
RUN nimble install -y --depsOnly
WORKDIR /app
COPY . .
RUN nimble build --verbose $NIM_PARAMS

FROM scratch
COPY --from=builder /app/app /app
COPY --from=builder /app/students.db /students.db
COPY --from=builder /app/README.md /README.md

ENTRYPOINT ["/app"]
