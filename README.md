Ubuntu based image with the following tools installed :
- NetCDF C library built HDF5 support
- CDO : climate operator command line tools
- eccodes : ECMWF library

Build :
```bash
docker build -t netcdf-image .
```
Run and mount current directory inside container :
```bash
docker  run  -v $(pwd):$(pwd) -w $(pwd) -i -t  netcd-image
```

Then one can use CDO tools inside container, files on the mounted partition
