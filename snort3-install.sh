#!bin/bash
mkdir -p /data/install
cd /data/snort3

#### Dependencies ####
apt-get update && apt-get install cmake g++ libhwloc-dev libluajit-5.1-dev libssl-dev libpcre3-dev pkg-config zlib1g-dev bison flex libpcap-dev libdumbnet-dev libhsm-bin -y

#### Downloads ####
wget http://www.tcpdump.org/release/libpcap-1.8.1.tar.gz
git clone https://github.com/snort3/snort3.git
wget https://snort.org/downloads/snortplus/daq-2.2.2.tar.gz
git clone https://github.com/dugsong/libdnet.git

#### Install packages #####

## DAQ ##
cd /data/install
tar xvfz daq-2.2.2.tar.gz
cd /data/install/daq-2.2.2/
./configure
make
make install

## Snort3 ##
cd /data/install/snort3
export my_path=/data/install/snort3/
./configure_cmake.sh --prefix=$my_path
cd build
make -j $(nproc) install
