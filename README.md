# jetson_opengl_docker

## Introduction
This is a Dockerfile to launch OpenGL application on NVIDIA Jetson devices.  
And, this project has the following Dockerfile.

- [master](https://github.com/atinfinity/jetson_opengl_docker/tree/master)
  - This Dockerfile uses [nvcr.io/nvidia/l4t-base](https://ngc.nvidia.com/catalog/containers/nvidia:l4t-base) as base Docker image.
- [ubuntu1604](https://github.com/atinfinity/jetson_opengl_docker/tree/ubuntu1604)
  - This Dockerfile uses [arm64v8/ubuntu:16.04](https://hub.docker.com/r/arm64v8/ubuntu/) as base Docker image.
- [ubuntu1804](https://github.com/atinfinity/jetson_opengl_docker/tree/ubuntu1804)
  - This Dockerfile uses [arm64v8/ubuntu:18.04](https://hub.docker.com/r/arm64v8/ubuntu/) as base Docker image.

## Requirements
- Docker

## Preparation
### Build Docker image
```
$ docker build -t jetson/opengl:ubuntu1804 .
```

### Create Docker container
```
$ ./launch_container.sh
```

## Launch OpenGL application
```
$ glxgears
```
