FROM nvidia/cuda:11.4.0-devel-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y git gcc g++ make cmake wget python3 \
    && rm -rf /var/lib/apt/lists/*
# install openmpi
ARG OPENMPI_VERSION_MAJOR_MINOR=4.1
ARG OPENMPI_VERSION=4.1.4
ARG OPENMPI_ROOT=/opt/openmpi-${OPENMPI_VERSI}
RUN cd /tmp \
    && wget -O openmpi-${OPENMPI_VERSION}.tar.gz https://download.open-mpi.org/release/open-mpi/v${OPENMPI_VERSION_MAJOR_MINOR}/openmpi-${OPENMPI_VERSION}.tar.gz \
    && tar -xzvf openmpi-${OPENMPI_VERSION}.tar.gz && cd openmpi-${OPENMPI_VERSION} \
    && ./configure --prefix=${OPENMPI_ROOT} && make -j && make install \
    && rm -rf /tmp/*
ENV PATH="$PATH:${OPENMPI_ROOT}/bin"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${OPENMPI_ROOT}/lib"
# install gromacs
ARG GROMACS_VERSION=2022.2
ARG GROMACS_ROOT=/opt/gromacs-${GROMACS_VERSION}
RUN cd /tmp \
    && git clone https://gitlab.com/gromacs/gromacs.git && cd gromacs && git checkout v${GROMACS_VERSION} \
    && mkdir build && cd build \
    && export CC=/usr/bin/gcc && export CXX=/usr/bin/g++ \
    && cmake .. -DGMX_GPU=CUDA -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda -DGMX_MPI=ON -DGMX_BUILD_OWN_FFTW=ON -DGMX_FFT_LIBRARY=fftw3 -DCMAKE_INSTALL_PREFIX=${GROMACS_ROOT} \
    && make -j && make install \
    && rm -rf /tmp/* \
    && ln -s ${GROMACS_ROOT}/bin/gmx_mpi ${GROMACS_ROOT}/bin/gmx
ENV GMXPREFIX="${GROMACS_ROOT}"
ENV GMXBIN="${GMXPREFIX}/bin"
ENV GMXLDLIB="${GMXPREFIX}/lib"
ENV GMXMAN="${GMXPREFIX}/share/man"
ENV GMXDATA="${GMXPREFIX}/share/gromacs"
ENV GMXTOOLCHAINDIR="${GMXPREFIX}/share/cmake"
ENV GROMACS_DIR="${GMXPREFIX}"
ENV PATH="$PATH:$GMXBIN"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$GMXLIB"
ENV MANPATH="$MANPATH:$GMXMAN"
