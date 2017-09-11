#!/bin/bash

cat >> /etc/profile << EOF
export JAVA_HOME=/usr/lib/jvm/java
export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar
export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:$JAVA_HOME/bin:/usr/local/go/bin
export GOPATH=/home/veritas/go
EOF
