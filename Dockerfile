FROM ubuntu:focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata && apt-get -yq install gcc \
                      build-essential \
                      tar \
                      bzip2 \
                      m4 \
                      zlib1g-dev \
                      libopenmpi-dev \
                      libxml2-dev libcurl4-openssl-dev

COPY hdf5-1.14.3.tar.gz hdf5-1.14.3.tar.gz
COPY netcdf-c-4.9.2.tar.gz netcdf-c-4.9.2.tar.gz

#Build HDF5
RUN tar xzvf hdf5-1.14.3.tar.gz && \
    cd hdf5-1.14.3 && \
    CC=mpicc ./configure --enable-parallel --prefix=/usr/local/hdf5 && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -rf /hdf5-1.14.3 /hdf5-1.14.3.tar.gz 

#Build netcdf
RUN tar xzvf netcdf-c-4.9.2.tar.gz && \
    cd netcdf-c-4.9.2 && \
    ./configure --prefix=/usr/local/netcdf \ 
                CC=mpicc \
                LDFLAGS=-L/usr/local/hdf5/lib \
                CFLAGS=-I/usr/local/hdf5/include && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -rf netcdf-c-4.9.2 netcdf-c-4.9.2.tar.gz
