FROM ubuntu:focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata && apt-get -yq install gcc \
  build-essential \
  tar \
  bzip2 \
  m4 \
  cmake libaec-dev \
  zlib1g-dev \
  gfortran \
  libxml2-dev libcurl4-openssl-dev \
  python3-dev libproj-dev \
  gsl-bin libgsl-dev \
  antlr libantlr-dev \
  bison flex gcc g++ \
  udunits-bin libudunits2-0 libudunits2-dev


# Build HDF5
ARG HDF5_VERSION="1.14.3"
COPY hdf5-${HDF5_VERSION}.tar.gz hdf5-${HDF5_VERSION}.tar.gz
RUN tar xzvf hdf5-${HDF5_VERSION}.tar.gz && \
    cd hdf5-${HDF5_VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -rf /hdf5-${HDF5_VERSION} /hdf5-${HDF5_VERSION}.tar.gz 

#Build netcdf
ARG NETCDF_VERSION="4.9.2"
COPY netcdf-c-${NETCDF_VERSION}.tar.gz netcdf-c-${NETCDF_VERSION}.tar.gz
RUN tar xzvf netcdf-c-${NETCDF_VERSION}.tar.gz && \
    cd netcdf-c-${NETCDF_VERSION} && \
    ./configure --prefix=/usr/local --with-hdf5=/usr/local && \ 
    make -j4 && \
    make install && \
    cd .. && \
    rm -rf /netcdf-c-${NETCDF_VERSION} /netcdf-c-${NETCDF_VERSION}.tar.gz

# Build eccodes
ARG ECCODES_VERSION="2.32.1"
COPY eccodes-${ECCODES_VERSION}-Source.tar.gz eccodes-${ECCODES_VERSION}-Source.tar.gz
RUN tar zxvf  eccodes-${ECCODES_VERSION}-Source.tar.gz && \
    cd eccodes-${ECCODES_VERSION}-Source  && \
    mkdir build && cd build  && \
    cmake .. && \
    make -j4 && make install && \
    cd / && \
    rm -rf  /eccodes-${ECCODES_VERSION}-Source.tar.gz /eccodes-${ECCODES_VERSION}-Source 

# Build CDO
ARG CDO_VERSION="2.3.0"
COPY cdo-${CDO_VERSION}.tar.gz cdo-${CDO_VERSION}.tar.gz
RUN tar zxvf cdo-${CDO_VERSION}.tar.gz && \
    cd cdo-${CDO_VERSION} && \
        ./configure  --with-eccodes --with-netcdf=/usr/local \
        --with-hdf5=/usr/local --enable-netcdf4 --enable-hdf5 \
        --prefix=/usr/local && \
   make -j4 && make install && \
   cd / && \
   rm -rf /cdo-${CDO_VERSION}.tar.gz /cdo-${CDO_VERSION}

# Refresh lib links
RUN /sbin/ldconfig

# Build NCO
ARG NCO_VERSION="5.1.9"
COPY nco-${NCO_VERSION}.tar.gz nco-${NCO_VERSION}.tar.gz
RUN  tar xvzf nco-${NCO_VERSION}.tar.gz && \
      cd nco-${NCO_VERSION} && \
      ./configure --prefix=/usr/local  
RUN cd nco-${NCO_VERSION} && make && make install  && \
      cd / && \
      rm -rf /nco-${NCO_VERSION}.tar.gz  /nco-${NCO_VERSION}

# Refresh lib links
RUN /sbin/ldconfig

