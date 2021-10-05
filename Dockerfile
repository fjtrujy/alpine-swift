FROM alpine:latest

# Install required dependencies
RUN apk add \
  build-base \
  curl \
  bash \
  clang clang-dev llvm compiler-rt compiler-rt-static lld musl-dev gcc \
  cmake \
  git \
  icu-dev \
  openssl-dev \
  libedit-dev \
  icu-dev \
  ncurses-dev \
  python3 \
  sqlite-dev \
  libxml2-dev \
  ninja \
  pkgconfig \
  python2 \
  rsync \
  swig \
  tzdata \
  unzip \
  libuuid \
  re2c

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  sccache

# We require to have six module
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
  python get-pip.py
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
