FROM alpine:latest

# Install required dependencies
RUN apk add \
  build-base \
  binutils \
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
  python3 py3-pip \
  sqlite \
  tzdata \
  zlib-dev \
  ninja \
  sccache

RUN pip install six

# Check dependencies https://github.com/apple/swift/blob/main/docs/HowToGuides/GettingStarted.md#spot-check-dependencies
RUN cmake --version
RUN python3 --version
RUN ninja --version
RUN sccache --version

# Clone repo and dependencies
RUN git clone https://github.com/apple/swift.git
RUN ./swift/utils/update-checkout --clone

# Compile and choose installation folder
RUN ./swift/utils/build-script --preset=buildbot_linux,no_test install_destdir=/swift-install installable_package=/swift-package/swift.tar.gz


# Second stage of Dockerfile
FROM alpine:latest

# Copy Swift
COPY --from=0 swift-install/usr/ /usr/local/
