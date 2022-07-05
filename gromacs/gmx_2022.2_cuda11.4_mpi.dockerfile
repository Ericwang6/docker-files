FROM nvidia/cuda:11.4.0-devel-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y git gcc g++ make cmake wget python3 \
    && rm -rf /var/lib/apt/lists/*
# install openmpi
ARG OPENMPI_VERSION_MAJOR_MINOR=4.1
ARG OPENMPI_VERSION=4.1.4
RUN cd /tmp \
    && wget -O openmpi-${OPENMPI_VERSION}.tar.gz https://download.open-mpi.org/release/open-mpi/v${OPENMPI_VERSION_MAJOR_MINOR}/openmpi-${OPENMPI_VERSION}.tar.gz \
    && tar -xzvf openmpi-${OPENMPI_VERSION}.tar.gz && cd openmpi-${OPENMPI_VERSION} \
    && ./configure --prefix=/usr && make -j && make install \
    && rm -rf /tmp/
# install gromacs
RUN apt-get install -y python3
ARG GROMACS_VERSION=2022.2
RUN cd /tmp \
    && git clone https://gitlab.com/gromacs/gromacs.git && cd gromacs && git checkout v${GROMACS_VERSION} \
    && mkdir build && cd build \
    && export CC=/usr/bin/gcc && export CXX=/usr/bin/g++ \
    && cmake .. -DGMX_GPU=CUDA -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda -DGMX_MPI=ON -DGMX_BUILD_OWN_FFTW=ON -DGMX_FFT_LIBRARY=fftw3 -DCMAKE_INSTALL_PREFIX=/usr \
    && make && make install \
    && rm -rf /tmp/ \
    && ln -s /usr/bin/gmx_mpi /usr/bin/gmx
