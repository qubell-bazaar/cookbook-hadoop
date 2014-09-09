#!/bin/bash
ext=
jdk=jdk1.6.0_31

if [ ! -d "/usr/lib/jvm" ]; then
    mkdir -p "/usr/lib/jvm"
fi

if [ ! -d "/usr/lib/jvm-exports" ]; then
    mkdir -p "/usr/lib/jvm-exports"
fi

ln -fs /usr/java/$jdk /usr/lib/jvm/

alternatives \
  --install /usr/bin/java java /usr/lib/jvm/$jdk/bin/java 20000 \
  --slave /usr/lib/jvm/jre jre /usr/lib/jvm/$jdk/jre \
  --slave /usr/lib/jvm-exports/jre jre_exports /usr/lib/jvm/$jdk/jre/lib \
  --slave /usr/bin/keytool keytool /usr/lib/jvm/$jdk/bin/keytool \
  --slave /usr/bin/orbd orbd /usr/lib/jvm/$jdk/bin/orbd \
  --slave /usr/bin/pack200 pack200 /usr/lib/jvm/$jdk/bin/pack200 \
  --slave /usr/bin/rmid rmid /usr/lib/jvm/$jdk/bin/rmid \
  --slave /usr/bin/rmiregistry rmiregistry /usr/lib/jvm/$jdk/bin/rmiregistry \
  --slave /usr/bin/servertool servertool /usr/lib/jvm/$jdk/bin/servertool \
  --slave /usr/bin/tnameserv tnameserv /usr/lib/jvm/$jdk/bin/tnameserv \
  --slave /usr/bin/unpack200 unpack200 /usr/lib/jvm/$jdk/bin/unpack200 \
  --slave /usr/share/man/man1/java.1$ext java.1$ext \
  /usr/java/$jdk/man/man1/java.1$ext \
  --slave /usr/share/man/man1/keytool.1$ext keytool.1$ext \
  /usr/java/$jdk/man/man1/keytool.1$ext \
  --slave /usr/share/man/man1/orbd.1$ext orbd.1$ext \
  /usr/java/$jdk/man/man1/orbd.1$ext \
  --slave /usr/share/man/man1/pack200.1$ext pack200.1$ext \
  /usr/java/$jdk/man/man1/pack200.1$ext \
  --slave /usr/share/man/man1/rmid.1$ext rmid.1$ext \
  /usr/java/$jdk/man/man1/rmid.1$ext \
  --slave /usr/share/man/man1/rmiregistry.1$ext rmiregistry.1$ext \
  /usr/java/$jdk/man/man1/rmiregistry.1$ext \
  --slave /usr/share/man/man1/servertool.1$ext servertool.1$ext \
  /usr/java/$jdk/man/man1/servertool.1$ext \
  --slave /usr/share/man/man1/tnameserv.1$ext tnameserv.1$ext \
  /usr/java/$jdk/man/man1/tnameserv.1$ext \
  --slave /usr/share/man/man1/unpack200.1$ext unpack200.1$ext \
  /usr/java/$jdk/man/man1/unpack200.1$ext


alternatives \
  --install /usr/lib/jvm/jre-1.6.0 \
  jre_1.6.0 /usr/lib/jvm/$jdk/jre 20000 \
  --slave /usr/lib/jvm-exports/jre-1.6.0 \
  jre_1.6.0_exports /usr/lib/jvm/$jdk/jre/lib


alternatives \
  --install /usr/bin/javac javac /usr/lib/jvm/$jdk/bin/javac 20000 \
  --slave /usr/lib/jvm/java java_sdk /usr/lib/jvm/$jdk \
  --slave /usr/lib/jvm-exports/java java_sdk_exports /usr/lib/jvm-exports/$jdk \
  --slave /usr/bin/appletviewer appletviewer /usr/lib/jvm/$jdk/bin/appletviewer \
  --slave /usr/bin/apt apt /usr/lib/jvm/$jdk/bin/apt \
  --slave /usr/bin/extcheck extcheck /usr/lib/jvm/$jdk/bin/extcheck \
  --slave /usr/bin/jar jar /usr/lib/jvm/$jdk/bin/jar \
  --slave /usr/bin/jarsigner jarsigner /usr/lib/jvm/$jdk/bin/jarsigner \
  --slave /usr/bin/javadoc javadoc /usr/lib/jvm/$jdk/bin/javadoc \
  --slave /usr/bin/javah javah /usr/lib/jvm/$jdk/bin/javah \
  --slave /usr/bin/javap javap /usr/lib/jvm/$jdk/bin/javap \
  --slave /usr/bin/jconsole jconsole /usr/lib/jvm/$jdk/bin/jconsole \
  --slave /usr/bin/jdb jdb /usr/lib/jvm/$jdk/bin/jdb \
  --slave /usr/bin/jhat jhat /usr/lib/jvm/$jdk/bin/jhat \
  --slave /usr/bin/jinfo jinfo /usr/lib/jvm/$jdk/bin/jinfo \
  --slave /usr/bin/jmap jmap /usr/lib/jvm/$jdk/bin/jmap \
  --slave /usr/bin/jps jps /usr/lib/jvm/$jdk/bin/jps \
  --slave /usr/bin/jrunscript jrunscript /usr/lib/jvm/$jdk/bin/jrunscript \
  --slave /usr/bin/jsadebugd jsadebugd /usr/lib/jvm/$jdk/bin/jsadebugd \
  --slave /usr/bin/jstack jstack /usr/lib/jvm/$jdk/bin/jstack \
  --slave /usr/bin/jstat jstat /usr/lib/jvm/$jdk/bin/jstat \
  --slave /usr/bin/jstatd jstatd /usr/lib/jvm/$jdk/bin/jstatd \
  --slave /usr/bin/native2ascii native2ascii /usr/lib/jvm/$jdk/bin/native2ascii \
  --slave /usr/bin/policytool policytool /usr/lib/jvm/$jdk/bin/policytool \
  --slave /usr/bin/rmic rmic /usr/lib/jvm/$jdk/bin/rmic \
  --slave /usr/bin/schemagen schemagen /usr/lib/jvm/$jdk/bin/schemagen \
  --slave /usr/bin/serialver serialver /usr/lib/jvm/$jdk/bin/serialver \
  --slave /usr/bin/wsgen wsgen /usr/lib/jvm/$jdk/bin/wsgen \
  --slave /usr/bin/wsimport wsimport /usr/lib/jvm/$jdk/bin/wsimport \
  --slave /usr/bin/xjc xjc /usr/lib/jvm/$jdk/bin/xjc \
  --slave /usr/share/man/man1/appletviewer.1$ext appletviewer.1$ext \
  /usr/java/$jdk/man/man1/appletviewer.1$ext \
  --slave /usr/share/man/man1/apt.1$ext apt.1$ext \
  /usr/java/$jdk/man/man1/apt.1$ext \
  --slave /usr/share/man/man1/extcheck.1$ext extcheck.1$ext \
  /usr/java/$jdk/man/man1/extcheck.1$ext \
  --slave /usr/share/man/man1/jar.1$ext jar.1$ext \
  /usr/java/$jdk/man/man1/jar.1$ext \
  --slave /usr/share/man/man1/jarsigner.1$ext jarsigner.1$ext \
  /usr/java/$jdk/man/man1/jarsigner.1$ext \
  --slave /usr/share/man/man1/javac.1$ext javac.1$ext \
  /usr/java/$jdk/man/man1/javac.1$ext \
  --slave /usr/share/man/man1/javadoc.1$ext javadoc.1$ext \
  /usr/java/$jdk/man/man1/javadoc.1$ext \
  --slave /usr/share/man/man1/javah.1$ext javah.1$ext \
  /usr/java/$jdk/man/man1/javah.1$ext \
  --slave /usr/share/man/man1/javap.1$ext javap.1$ext \
  /usr/java/$jdk/man/man1/javap.1$ext \
  --slave /usr/share/man/man1/jconsole.1$ext jconsole.1$ext \
  /usr/java/$jdk/man/man1/jconsole.1$ext \
  --slave /usr/share/man/man1/jdb.1$ext jdb.1$ext \
  /usr/java/$jdk/man/man1/jdb.1$ext \
  --slave /usr/share/man/man1/jhat.1$ext jhat.1$ext \
  /usr/java/$jdk/man/man1/jhat.1$ext \
  --slave /usr/share/man/man1/jinfo.1$ext jinfo.1$ext \
  /usr/java/$jdk/man/man1/jinfo.1$ext \
  --slave /usr/share/man/man1/jmap.1$ext jmap.1$ext \
  /usr/java/$jdk/man/man1/jmap.1$ext \
  --slave /usr/share/man/man1/jps.1$ext jps.1$ext \
  /usr/java/$jdk/man/man1/jps.1$ext \
  --slave /usr/share/man/man1/jrunscript.1$ext jrunscript.1$ext \
  /usr/java/$jdk/man/man1/jrunscript.1$ext \
  --slave /usr/share/man/man1/jsadebugd.1$ext jsadebugd.1$ext \
  /usr/java/$jdk/man/man1/jsadebugd.1$ext \
  --slave /usr/share/man/man1/jstack.1$ext jstack.1$ext \
  /usr/java/$jdk/man/man1/jstack.1$ext \
  --slave /usr/share/man/man1/jstat.1$ext jstat.1$ext \
  /usr/java/$jdk/man/man1/jstat.1$ext \
  --slave /usr/share/man/man1/jstatd.1$ext jstatd.1$ext \
  /usr/java/$jdk/man/man1/jstatd.1$ext \
  --slave /usr/share/man/man1/native2ascii.1$ext native2ascii.1$ext \
  /usr/java/$jdk/man/man1/native2ascii.1$ext \
  --slave /usr/share/man/man1/policytool.1$ext policytool.1$ext \
  /usr/java/$jdk/man/man1/policytool.1$ext \
  --slave /usr/share/man/man1/rmic.1$ext rmic.1$ext \
  /usr/java/$jdk/man/man1/rmic.1$ext \
  --slave /usr/share/man/man1/schemagen.1$ext schemagen.1$ext \
  /usr/java/$jdk/man/man1/schemagen.1$ext \
  --slave /usr/share/man/man1/serialver.1$ext serialver.1$ext \
  /usr/java/$jdk/man/man1/serialver.1$ext \
  --slave /usr/share/man/man1/wsgen.1$ext wsgen.1$ext \
  /usr/java/$jdk/man/man1/wsgen.1$ext \
  --slave /usr/share/man/man1/wsimport.1$ext wsimport.1$ext \
  /usr/java/$jdk/man/man1/wsimport.1$ext \
  --slave /usr/share/man/man1/xjc.1$ext xjc.1$ext \
  /usr/java/$jdk/man/man1/xjc.1$ext


alternatives \
  --install /usr/lib/jvm/java-1.6.0 \
  java_sdk_1.6.0 /usr/lib/jvm/$jdk 20000 \
  --slave /usr/lib/jvm-exports/java-1.6.0 \
  java_sdk_1.6.0_exports /usr/lib/jvm/$jdk/jre/lib


#  alternatives --remove java /usr/lib/jvm/$jdk/bin/java
#  alternatives --remove jre_1.6.0 /usr/lib/jvm/$jdk/jre
#  alternatives --remove javac /usr/lib/jvm/$jdk/bin/javac
#  alternatives --remove java_sdk_1.6.0 /usr/lib/jvm/$jdk
