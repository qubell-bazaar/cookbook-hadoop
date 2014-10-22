#!/bin/bash
if [ ! -d "/usr/lib/jvm" ]; then
    mkdir -p "/usr/lib/jvm"
fi

ln -fs /usr/java/jdk1.6.0_31 /usr/lib/jvm/java
