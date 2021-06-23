#!/bin/sh

install_verilator(){
  sudo apt install -y git make autoconf g++ flex libfl-dev bison  # First time prerequisites
  git clone http://git.veripool.org/git/verilator   # Only first time
  unset VERILATOR_ROOT  # For bash
  cd verilator
  git pull        # Make sure we're up-to-date
  git checkout v4.040
  autoconf        # Create ./configure script
  ./configure --prefix ~/tools
  make -j$(nproc)
  make install
  cd ..
}

install_ghdl(){
  sudo apt install -y gnat-9  libgnat-9 zlib1g-dev libboost-dev
  git clone https://github.com/ghdl/ghdl ghdl-build && cd ghdl-build
  git reset --hard "0316f95368837dc163173e7ca52f37ecd8d3591d"
  mkdir build
  cd build
  ../configure --prefix=~/tools
  make -j$(nproc)
  make install
  cd ..
}

install_iverilog(){
  sudo apt install -y gperf readline-common bison flex libfl-dev
  curl -fsSL https://github.com/steveicarus/iverilog/archive/v10_3.tar.gz | tar -xvz
  cd iverilog-10_3
  autoconf
  ./configure  --prefix ~/tools
  make -j$(nproc)
  make install
  cd ..
}

install_cocotb(){
  pip3 install --user cocotb
  sudo apt install -y git make gcc g++ swig python3-dev
}

purge_cocotb(){
  # Force cocotb to compile VPI to avoid race condition when tests are start in parallel
  cd tester/src/test/python/spinal/Dummy
  make TOPLEVEL_LANG=verilog
  make TOPLEVEL_LANG=vhdl
  cd ../../../../../..
}

install_packages(){
  sudo apt install -y gnat-9  libgnat-9 zlib1g-dev libboost-dev
}

install_tools(){
  install_verilator
  install_ghdl
  install_iverilog
  install_cocotb
}