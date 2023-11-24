Ubuntu based image with NetCDF C library built against HDF5

Build :
```bash
docker build -t netcdf-image .
```
Run and mount current directory inside container :
```bash
docker  run  -v $(pwd):$(pwd) -w $(pwd) -i -t  netcd-image
```
