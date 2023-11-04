# Start with the Ubuntu 16.04 base image
FROM ubuntu:16.04

# Avoid interaction with the user for apt-get install
ENV DEBIAN_FRONTEND noninteractive

# Run system update
RUN apt-get update -y \
    && apt-get install -y apt-utils

# Install required packages
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 \
    libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev \
    libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libboost-all-dev \
    software-properties-common git libminiupnpc-dev libzmq3-dev libqt4-dev 

# Add Bitcoin PPA
RUN add-apt-repository -y ppa:bitcoin/bitcoin \
    && apt-get update -y \
    && apt-get install -y libdb4.8-dev libdb4.8++-dev

RUN chmod +x src/leveldb/build_detect_platform

# Clone the repository and build the software
RUN git clone https://github.com/codenlighten/boundless.git \
    && cd boundless/src \
    && make -f makefile.unix \
    && cd .. \
    && qmake && make

# Set the default command for the container
CMD ["/bin/bash"]
