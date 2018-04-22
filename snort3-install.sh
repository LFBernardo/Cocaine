#!/bin/bash
################################################# NOTICE ##############################################
# The following has been optimized for dual core compiling. For make options the additional j3 has been used to assign 2 cores. 
# If you have more cores adjust this accordingly. This is core count +1 e.g. 4 cores you need j 5 and for 8 cores j 9.

#Apt based dependencies
apt-get update && apt-get install -y asciidoc autoconf autotools-dev bison build-essential  cmake cpputest dblatex flex g++  libpcre3-dev libdumbnet-dev libhwloc-dev  libhsm-bin libluajit-5.1-dev  liblzma-dev libnetfilter-queue-dev libpcap-dev libssl-dev libsqlite3-dev uuid-dev libtool openssl pkg-config source-highlight w3m zlib1g-dev
mkdir -p /data/install/

#Downloads
wget http://www.colm.net/files/colm/colm-0.13.0.5.tar.gz
wget http://www.colm.net/files/ragel/ragel-6.10.tar.gz
wget https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz
wget https://github.com/intel/hyperscan/archive/v4.7.0.tar.gz -O hyperscan-v4.7.0.tar.gz
wget https://downloads.sourceforge.net/project/safeclib/libsafec-10052013.tar.gz
wget https://github.com/google/flatbuffers/archive/master.tar.gz -O flatbuffers-master.tar.gz
wget https://www.snort.org/downloads/snortplus/daq-2.2.2.tar.gz

#Extract
tar xvzf colm-0.13.0.5.tar.gz
tar xzvf ragel-6.10.tar.gz
tar xvzf boost_1_65_1.tar.gz
tar xvfz hyperscan-v4.7.0.tar.gz
tar xvzf libsafec-10052013.tar.gz
tar xvzf flatbuffers-master.tar.gz
tar xvzf daq-2.2.2.tar.gz

## Safec < This isn't currently working as there is a bug (http://seclists.org/snort/2018/q1/269) You can uncomment the following lines
## or leave it in place as it doesn't interfere with anything. I will fix the script if needed once they have resolved the bug in the
## snort compiler.
## safec for runtime bounds checks on certain legacy C-library calls (this is optional but recommended):
cd /data/install/libsafec-10052013
./configure
make
make install

## Ragel/boost/hyperscan/colm
## Snort3 will use Hyperscan for fast pattern matching. Hyperscan requires Ragel and the Boost headers:

##Colm
cd /data/install/colm-0.13.0.5
./autogen
./configure
make -j3
make install -j3 

##Ragel
cd /data/install/ragel-6.10
./configure
make -j3
make install -j3

## Hyperscan requires the Boost C++ Libraries
## Install Hyperscan 4.7.0 from source, referencing the location of the Boost headers source directory:
cd /data/install/hyperscan-4.7.0
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=/data/install/boost_1_65_1/ /data/install/hyperscan-4.7.0
make -j3
make install -j3

## To test Hyperscan use the following
## cd /data/install/hyperscan-4.7.0
## ./bin/unit-hyperscan


## Snort has an optional requirement for flatbuffers, A memory efficient serialization library:
mkdir -p /data/install/flatbuffers-build
cd /data/install/flatbuffers-build
cmake /data/install/flatbuffers-master
make -j3
make install -j3

## DAQ install
cd /data/install/daq-2.2.2
./configure
make -j3 
make install -j3

##Update shared libraries:
ldconfig

cd /data/install/
git clone git://github.com/snortadmin/snort3.git
cd /data/install/snort3
./configure_cmake.sh --prefix=/ --enable-safec --enable-large-pcap --enable-shell
cd build
make -j3
make install -j3

echo 'export LUA_PATH=/usr/include/snort/lua/\?.lua\;\;' >> ~/.profile
echo 'export SNORT_LUA_PATH=/etc/snort' >> ~/.profile
. ~/.profile


#safec not being detected by snort3 compile process. Will attempt to resolve later
#hyperscan not compiling with snort3 resolved.
