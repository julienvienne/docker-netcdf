Ubuntu based image with NetCDF C library built against HDF5

Build :
docker build -t netcdf-image .

Run and mount current directory inside container :
docker  run  -v $(pwd):$(pwd) -w $(pwd) -i -t  netcd-image
