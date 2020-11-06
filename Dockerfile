FROM alpine:latest

# Install required dependencies
RUN apk add \
  build-base \
  binutils \
  gcc \
  clang clang-dev \
  git \
  musl-dev \
  cmake \
  curl \
  bash \
  glib-static \
  libbsd-dev \
  libedit \
  libedit-dev \
  icu-dev \
  libstdc++ \
  pkgconfig \
  python2 \
  sqlite \
  tzdata \
  zlib-dev

# We require to have six module
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python get-pip.py
RUN pip install six

# Clone repo and dependencies
RUN git clone https://github.com/apple/swift.git
RUN ./swift/utils/update-checkout --clone

# Compile and choose installation folder
RUN ./swift/utils/build-script --preset=buildbot_linux,no_test install_destdir=/swift-install installable_package=/swift-package/swift.tar.gz


# Second stage of Dockerfile
FROM alpine:latest

# Copy Swift
COPY --from=0 swift-install/usr/ /usr/local/
