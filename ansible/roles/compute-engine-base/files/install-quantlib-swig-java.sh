#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java
export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar
export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:$JAVA_HOME/bin

# Install QuantLib-SWIG for Java bindings
git clone https://github.com/lballabio/QuantLib-SWIG.git \
  && cd QuantLib-SWIG && git checkout v1.9.x  \
  && sh ./autogen.sh \
  && ./configure --disable-perl --disable-ruby --disable-mzscheme --disable-guile --disable-csharp --disable-ocaml --disable-r --disable-python --with-jdk-include=$JAVA_HOME/include --with-jdk-system-include=$JAVA_HOME/include/linux CXXFLAGS=-O3 \
  && make clean && make -C Java && make install -C Java \
  && cd ..