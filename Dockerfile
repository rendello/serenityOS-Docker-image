# base image
FROM debian:latest

# set working directory
WORKDIR .

#copy serenity repo
COPY ./serenity ./serenity

# install dependencies
RUN echo "deb http://http.us.debian.org/debian/ testing non-free contrib main" >> /etc/apt/sources.list
RUN apt update -y

#install gcc g++ 10
RUN apt install -y gcc-10 g++-10
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 900 --slave /usr/bin/g++ g++ /usr/bin/g++-10
RUN apt install -y genext2fs

#building dependencies
RUN apt install -y build-essential cmake curl libmpfr-dev libmpc-dev libgmp-dev e2fsprogs ninja-build qemu-system-i386 qemu-utils

WORKDIR ./serenity/Toolchain

#Building & create image
RUN bash BuildIt.sh

WORKDIR /serenity/Build/i686

RUN cmake ../.. -G Ninja
RUN ninja install
RUN ninja image
#RUN ninja run

#RUN /bin/bash