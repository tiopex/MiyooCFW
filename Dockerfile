FROM ubuntu:22.04 

LABEL description="Build environment for Miyoo Custom Firmware" 

COPY arm-miyoo-linux-uclibcgnueabi_sdk-buildroot.tar.gz /opt/miyoo

# set up some env properties (these are based on Arcnor's image)
ENV CROSS_ROOT=/opt/miyoo
ENV CROSS_TRIPLE=arm-miyoo-linux-uclibcgnueabi
ENV SYSROOT="${CROSS_ROOT}/${CROSS_TRIPLE}/sysroot"
ENV PATH="${PATH}:${CROSS_ROOT}/bin:${SYSROOT}/usr/bin"
ENV ARCH=arm
ENV CROSS_COMPILE="${CROSS_TRIPLE}-"

# install build dependencies
# first two lines are needed just to build the toolchain
# dosfstools & u-boot-tools are for mainboot generation scripts
# python-dev & swig are needed to build uboot
# finally, run some cleanup
# todo: 1) slim these down since we're not running buildroot in this image anymore
# todo: 2) consider splitting into a "slim" image with only the toolchain (and maybe git?) and a "full" image with more dev tools
ARG DEBIAN_FRONTEND=noninteractive
RUN cd /opt/miyoo && ./relocate-sdk.sh
RUN apt-get update && apt-get install -y file rename make gcc g++ \
    file wget cpio zip unzip rsync bc git \
    dosfstools u-boot-tools \
    python-dev swig && \
    apt-get -y autoremove && apt-get -y clean