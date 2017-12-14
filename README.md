# Debugging Cython code in rasterio

Build the container:

```
$ docker build . -t rasterio-debugging:dev
```

run it with the following command (see https://stackoverflow.com/a/46676907/554319):

```
$ docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it rasterio-debugging:dev /bin/bash
```

and start the debugger (see http://docs.cython.org/en/latest/src/userguide/debugging.html):

```
$ cygdb /usr/src/rasterio* -- --args $PYTHON
```
