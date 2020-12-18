FROM ubuntu:20.10

ENV QMEU_VERSION=5.2.0

RUN \
  apt update && \
  apt install wget ninja-build build-essential pkg-config zlib1g-dev pkg-config libglib2.0-dev binutils-dev libboost-all-dev autoconf libtool libssl-dev libpixman-1-dev -y

RUN \
  wget https://download.qemu.org/qemu-"${QMEU_VERSION}".tar.xz && \
  tar xvJf qemu-"${QMEU_VERSION}".tar.xz

WORKDIR qemu-"${QMEU_VERSION}"
RUN \
  ./configure --target-list=ppc-softmmu && \
  make && \
  make install && \
  qemu-system-ppc --version

# Clean up
RUN \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

RUN mkdir -p /drives/
VOLUME /drives

# VNC
EXPOSE 5900

COPY start.sh /qemu-"${QMEU_VERSION}"/
CMD ["./start.sh"]
