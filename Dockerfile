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
                      python3-dev libproj-dev

COPY hdf5-1.14.3.tar.gz hdf5-1.14.3.tar.gz

# Build HDF5
RUN tar xzvf hdf5-1.14.3.tar.gz && \
    cd hdf5-1.14.3 && \
    ./configure --prefix=/usr/local && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -rf /hdf5-1.14.3 /hdf5-1.14.3.tar.gz 

#Build netcdf
COPY netcdf-c-4.9.2.tar.gz netcdf-c-4.9.2.tar.gz
RUN tar xzvf netcdf-c-4.9.2.tar.gz && \
    cd netcdf-c-4.9.2 && \
    ./configure --prefix=/usr/local --with-hdf5=/usr/local && \ 
    make -j4 && \
    make install && \
    cd .. && \
    rm -rf /netcdf-c-4.9.2 /netcdf-c-4.9.2.tar.gz

# Build eccodes
COPY eccodes-2.32.1-Source.tar.gz eccodes-2.32.1-Source.tar.gz
RUN tar zxvf  eccodes-2.32.1-Source.tar.gz && \
    cd eccodes-2.32.1-Source  && \
    mkdir build && cd build  && \
    cmake .. && \
    make -j4 && make install && \
    cd .. && \
    rm -rf  /eccodes-2.32.1-Source.tar.gz /eccodes-2.32.1-Source \

# Build CDO
COPY cdo-2.3.0.tar.gz cdo-2.3.0.tar.gz
RUN tar zxvf  cdo-2.3.0.tar.gz && \
    cd cdo-2.3.0 && \
        ./configure  --with-eccodes --with-netcdf=/usr/local \
        --with-hdf5=/usr/local --enable-netcdf4 --enable-hdf5 \
        --prefix=/usr/local && \
   make -j4 && make install && \
   cd .. && \
   rm -rf  /cdo-2.3.0.tar.gz /cdo-2.3.0

# Refresh lib links
RUN /sbin/ldconfig

