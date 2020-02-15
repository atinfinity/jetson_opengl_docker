# jetson_opengl_docker

## Introduction
This is a Dockerfile to launch OpenGL application on NVIDIA Jetson devices.

## Requirements
* Docker

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
