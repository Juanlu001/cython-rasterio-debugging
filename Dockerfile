# Debugging environment for Cython and rasterio
# Analyzed with https://www.fromlatest.io/
FROM debian:stable
LABEL maintainer="Juan Luis Cano <juanlu@satellogic.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    gdb-python2 \
    libgdal-dev \
    python-dbg \
    python-dev \
    unzip \
&& rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && python2.7-dbg get-pip.py

ENV PYTHON=python2.7-dbg
ENV PIP="$PYTHON -m pip"

RUN $PIP install numpy
RUN $PIP install cython pygments

# Drag dependencies, then uninstall rasterio
RUN $PIP install --pre rasterio && $PIP uninstall rasterio -y

# Download rasterio sources
RUN curl -LO https://github.com/mapbox/rasterio/archive/1.0a12.zip && unzip 1.0a12.zip -d /usr/src

COPY . /usr/src

RUN patch -i /usr/src/setup.patch /usr/src/rasterio*/setup.py

WORKDIR /usr/src/
RUN cd rasterio* && $PYTHON setup.py build_ext --inplace

RUN $PIP install --editable rasterio*
