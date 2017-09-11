#!/bin/bash

wget https://github.com/lballabio/QuantLib/archive/QuantLib-v1.9.2.tar.gz \
  && tar xf QuantLib-v1.9.2.tar.gz \
  && cd QuantLib-QuantLib-v1.9.2 \
  && ./autogen.sh \
  && ./configure \
  && make -j"$(nproc --all)" \
  && make install \
  && ldconfig \
  && cd .. && rm -rf QuantLib-QuantLib-v1.9.2 && rm -f QuantLib-v1.9.2.tar.gz