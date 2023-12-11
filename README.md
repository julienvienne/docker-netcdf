Ubuntu based image with the following tools installed :
- NetCDF C library built HDF5 support
- eccodes : ECMWF library
- CDO : climate operator command line tools with NetCDF, GRIB1 and GRIB2 support
- NCO : Netcdf Climate Operators

Build :
```bash
docker build -t netcdf-image .
```
Run and mount current directory inside container :
```bash
docker  run  -v $(pwd):$(pwd) -w $(pwd) -i -t  netcd-image
```

Then one can use CDO and NCO tools inside container, files on the mounted partition
