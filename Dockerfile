ARG BASE_IMAGE=alpine:3.12
FROM ${BASE_IMAGE}

# Install deps.
RUN set -xe; \
    apk add --update  --no-cache --virtual .runtime-deps \
        ca-certificates \
        tzdata;

# Create our group & user.
RUN set -xe; \
    addgroup -g 1000 -S hertz; \
    adduser -u 1000 -S -h /hertz -s /bin/sh -G hertz hertz;

# Set our working directory.
WORKDIR /hertz/src

RUN set -xe; \
    apk add --upate --no-cache \
        cmake \
        alpine-sdk \
        python3-dev \
        py3-pip \
        py3-mako \
        py3-pybind11-dev \
        git;

# Build Volk
ARG VOLK_VERSION=v2.3.0
RUN set -xe; \
    git clone https://github.com/gnuradio/volk.git; \
    cd volk; \
    git checkout "${VOLK_VERSION}"; \
    mkdir build; \
    cd build; \
    cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../; \
    make -j$(nproc); \
    ctest -j$(nproc) || echo "qa_volk_16i_32fc_dot_prod_32fc fails"; \
    make install

# Add additional build deps
RUN set -xe; \
    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    apk add --upate --no-cache \
        log4cpp-dev@testing \
        log4cpp@testing \
        thrift-dev@testing \
        thrift@testing; \
    apk add --update --no-cache \
        alsa-lib \
        alsa-lib-dev \
        autoconf \
        automake \
        bash \
        boost-dev \
        doxygen \
        fftw \
        fftw-dev \
        gmp \
        gmp-dev \
        gsl \
        gsl-dev \
        jack \
        jack-dev \
        man-pages \
        mandoc \
        mandoc-dev \
        mpd \
        oxygen \
        portaudio \
        portaudio-dev \
        py3-click \
        py3-click-plugins \
        py3-numpy \
        py3-numpy-dev \
        py3-qt5 \
        py3-qtwebengine \
        py3-scipy \
        py3-sphinx \
        qt5-qtbase \
        qt5-qtbase-dev \
        qt5-qtsvg \
        qt5-qtsvg-dev \
        qt5-qttools \
        qt5-qttools-dev \
        qt5-qtwebglplugin \
        qt5-qtwebglplugin-dev \
        qt5-qtwebkit \
        qt5-qtwebkit-dev \
        sdl \
        sdl-dev \
        subversion \
        swig \
        vim \
        zeromq \
        zeromq-dev;

# Build QWT
ARG QWT_VERSION=qwt-6.1
RUN set -xe; \
    svn export svn://svn.code.sf.net/p/qwt/code/branches/qwt-6.1; \
    cd qwt-6.1; \
    sed -r -i 's|^(\s+)QWT_INSTALL_PREFIX(\s+)=(\s+)\/usr\/local.*$|\1QWT_INSTALL_PREFIX\2=\3/usr|g' qwtconfig.pri; \
    qmake-qt5 qwt.pro; \
    make -j$(nproc); \
    make install;

# Build GNU Radio
ARG GNU_RADIO_VERSION=v3.8.2.0
RUN set -xe; \
    git clone https://github.com/gnuradio/gnuradio.git; \
    cd gnuradio; \
    git checkout "${GNU_RADIO_VERSION}"; \
    mkdir -p build; \
    cd build; \
    cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release  -DENABLE_INTERNAL_VOLK=OFF -DPYTHON_EXECUTABLE=/usr/bin/python3 ../; \
    make -j$(nproc); \
    make install;

# Ensure hertz ownership
RUN set -xe; \
    chown -R hertz:hertz /hertz

# Copy our entrypoint into the container.
COPY ./runtime-assets /

# Build arguments.
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION

# Labels / Metadata.
LABEL \
    org.opencontainers.image.authors="James Brink <brink.james@gmail.com>" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.description="Hertz Lattice (GNU Radio)" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.source="https://github.com/utensils/hertz-lattice" \
    org.opencontainers.image.title="Hertz Lattice" \
    org.opencontainers.image.vendor="Utensils Union" \
    org.opencontainers.image.version="${VERSION}"

# Drop down to our unprivileged user.
USER hertz

# Setup our environment variables.
ENV \
    PATH="/usr/local/bin:$PATH" \
    VERSION="${VERSION}"

# Set the entrypoint.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Set the default command
CMD ["/bin/sh"]