FROM alpine:latest

# Install required dependencies
RUN apk add \
  build-base \
  clang \
  cmake \
  git \
  icu-dev \
  openssl-dev \
  libedit-dev \
  icu-dev \
  ncurses-dev \
  python3-dev \
  python3 \
  sqlite-dev \
  libxml2-dev \
  ninja \
  pkgconfig \
  python2-dev \
  py3-pip \
  py3-setuptools \
  rsync \
  swig \
  tzdata \
  unzip \
  libuuid

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
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


RUN sccache --start-server

# Compile and choose installation folder
RUN ./swift/utils/build-script --preset=buildbot_linux,no_test install_destdir=/swift-install installable_package=/swift-package/swift.tar.gz


# Second stage of Dockerfile
FROM alpine:latest

# Copy Swift
COPY --from=0 swift-install/usr/ /usr/local/
