#!/bin/bash
apt-get update && apt-get install -y asciidoc autoconf autotools-dev bison build-essential  cmake cpputest dblatex flex g++  libpcre3-dev libdumbnet-dev libhwloc-dev  libhsm-bin libluajit-5.1-dev  liblzma-dev libnetfilter-queue-dev libpcap-dev libssl-dev libsqlite3-dev uuid-dev libtool openssl pkg-config source-highlight w3m zlib1g-dev

## Safec
## Download and install safec for runtime bounds checks on certain legacy C-library calls (this is optional but recommended):
mkdir -p /data/install/
cd /data/install/
wget https://downloads.sourceforge.net/project/safeclib/libsafec-10052013.tar.gz
tar xvzf libsafec-10052013.tar.gz
cd libsafec-10052013
./configure
make
make install

## Ragel
## Snort3 will use Hyperscan for fast pattern matching. Hyperscan requires Ragel and the Boost headers:

##Colm is required for Ragel
cd /data/install
wget http://www.colm.net/files/colm/colm-0.13.0.5.tar.gz
tar xvzf colm-0.13.0.5.tar.gz
cd colm-0.13.0.5
./autogen
./configure
make
make install

##Ragel
cd /data/install
wget http://www.colm.net/files/ragel/ragel-6.10.tar.gz
tar xzvf ragel-6.10.tar.gz
cd ragel-6.10
./configure
make
sudo make install


#### Ragel 7 needs work done to make it work
#cd /data/install/
#wget http://www.colm.net/files/ragel/ragel-7.0.0.10.tar.gz
#tar xvzf ragel-7.0.0.10.tar.gz
#cd ragel-7.0.0.10
#./configure
#make
#sudo make install

## Hyperscan requires the Boost C++ Libraries
cd /data/install
wget https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz
tar xvzf boost_1_65_1.tar.gz
cd boost_1_65_1


## Install Hyperscan 4.7.0 from source, referencing the location of the Boost headers source directory:
cd /data/install
wget https://github.com/intel/hyperscan/archive/v4.7.0.tar.gz
tar xvfz v4.7.0.tar.gz
cd /data/install/hyperscan-4.7.0
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=/data/install/boost_1_65_1/ /data/install/hyperscan-4.7.0
make
make install

## To test Hyperscan use the following
## cd /data/install/hyperscan-4.7.0
## ./bin/unit-hyperscan


## Snort has an optional requirement for flatbuffers, A memory efficient serialization library:
cd /data/install/
wget https://github.com/google/flatbuffers/archive/master.tar.gz -O flatbuffers-master.tar.gz
tar xvzf flatbuffers-master.tar.gz
mkdir flatbuffers-build
cd flatbuffers-build
cmake ../flatbuffers-master
make
make install

## DAQ install
cd /data/install/
wget https://www.snort.org/downloads/snortplus/daq-2.2.2.tar.gz
tar -xvzf daq-2.2.2.tar.gz
cd daq-2.2.2
./configure
make
make install


##Update shared libraries:
ldconfig

cd /data/install/
git clone git://github.com/snortadmin/snort3.git
cd snort3
./configure_cmake.sh --prefix=/opt/snort --enable-large-pcap --enable-shell
cd build
make
make install


#Hypescan and safec not being detected by snort3 compile process. Will attempt to resolve later
