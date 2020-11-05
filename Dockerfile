FROM alpine:latest

# Install required dependencies
RUN apk add \
  git \
  cmake \
  curl \
  python2 \
  python3 \
  ninja \
  bash \
  build-base \
  g++ \
  screen \
  htop

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python get-pip.py
RUN pip install six

RUN git clone https://github.com/apple/swift.git
RUN ./swift/utils/update-checkout --clone


# Second stage of Dockerfile
# We CAN NOT use alpine:latest because we need an alpine version based in glibc for aapt2
FROM alpine:latest

# Copy Firebase
# COPY --from=0 /firebase /usr/bin/firebase