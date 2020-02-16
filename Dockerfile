FROM arm64v8/ubuntu:16.04

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# add new sudo user
ENV USERNAME opengl
ENV HOME /home/$USERNAME
RUN useradd -m $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    mkdir /etc/sudoers.d && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    # Replace 1000 with your user/group id
    usermod  --uid 1000 $USERNAME && \
    groupmod --gid 1000 $USERNAME && \
    gpasswd -a $USERNAME video

# install package
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        sudo \
        build-essential \
        git \
        less \
        emacs \
        tmux \
        bash-completion \
        command-not-found \
        software-properties-common \
        xdg-user-dirs \
        xsel \
        mesa-utils \
        libglu1-mesa-dev \
        libgles2-mesa-dev \
        freeglut3-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Addtional package for libglvnd
RUN apt-get update && apt-get install -y --no-install-recommends \
        automake \
        autoconf \
        libtool \
        pkg-config \
        libxext-dev \
        libx11-dev \
        x11proto-gl-dev \
        dbus \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install libglvnd
WORKDIR /opt
RUN git clone -b v1.3.0 https://github.com/NVIDIA/libglvnd.git && \
    cd libglvnd && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib/aarch64-linux-gnu && \
    make -j"$(nproc)" install-strip && \
    echo '/usr/local/lib/aarch64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    rm /etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf && \
    rm /etc/ld.so.conf.d/aarch64-linux-gnu_EGL.conf && \
    ln -s /usr/lib/aarch64-linux-gnu/tegra/ld.so.conf /etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf && \
    ln -s /usr/lib/aarch64-linux-gnu/tegra-egl/ld.so.conf /etc/ld.so.conf.d/aarch64-linux-gnu_EGL.conf && \
    ldconfig && \
    cd /usr/lib/aarch64-linux-gnu && \
    rm libGL.so && \
    rm libEGL.so && \
    rm libGLESv2.so && \
    ln -s /usr/local/lib/aarch64-linux-gnu/libGL.so libGL.so && \
    ln -s /usr/local/lib/aarch64-linux-gnu/libGLX.so libGLX.so && \
    ln -s /usr/local/lib/aarch64-linux-gnu/libEGL.so libEGL.so && \
    ln -s /usr/local/lib/aarch64-linux-gnu/libGLESv2.so libGLESv2.so && \
    rm -rf /opt/libglvnd

RUN mkdir -p /usr/local/share/glvnd/egl_vendor.d && \
    echo '{ "file_format_version" : "1.0.0", "ICD" : { "library_path" : "libEGL_nvidia.so.0" } }' > /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json

USER $USERNAME
WORKDIR /home/$USERNAME
SHELL ["/bin/bash", "-c"]
RUN echo "export LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra:/usr/lib/aarch64-linux-gnu/tegra-egl:$LD_LIBRARY_PATH" >> ~/.bashrc && \
    echo "export PATH=/usr/local/cuda/bin:$PATH" >> ~/.bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH" >> ~/.bashrc && \
    source ~/.bashrc
