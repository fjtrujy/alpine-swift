FROM alpine:latest

# Install required dependencies
RUN apk add \
  build-base \
  binutils \
  gcc \
  git \
  cmake \
  curl \
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

RUN git clone https://github.com/apple/swift.git
RUN ./swift/utils/update-checkout --clone

# Compile and choose installation folder
RUN ./swift/utils/build-script --preset=buildbot_linux,no_test install_destdir=/swift-install installable_package=/swift-package/swift.tar.gz


# Second stage of Dockerfile
FROM alpine:latest

# Copy Swift
COPY --from=0 swift-install/usr/ /usr/local/
