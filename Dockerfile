FROM frolvlad/alpine-glibc

# Install required dependencies
RUN apk add \
  build-base \
  binutils \
  gcc \
  clang clang-dev \
  git \
  cmake \
  curl \
  bash \
  pkgconfig \
  python2

# We require to have six module
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python get-pip.py
RUN pip install six

# Clone repo and dependencies
RUN git clone https://github.com/apple/swift.git
RUN ./swift/utils/update-checkout --clone

# Compile and choose installation folder
RUN ./swift/utils/build-script --debug


# Second stage of Dockerfile
FROM alpine:latest

# Copy Swift
COPY --from=0 swift-install/usr/ /usr/local/
