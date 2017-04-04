# based on https://registry.hub.docker.com/u/samtstern/android-sdk/dockerfile/ with openjdk-8
FROM java:8

MAINTAINER Andrew Pettey <andrew.pettey@olx.com>

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libstdc++6:i386 zlib1g:i386 libncurses5:i386 unzip:i386 wget:i386 --no-install-recommends && \
    apt-get -y install --reinstall locales && \
    dpkg-reconfigure locales && \
    localedef --list-archive && locale -a &&  \
    update-locale &&  \
    apt-get clean

# Download and unzip SDK
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
RUN wget "${ANDROID_SDK_URL}" -P /tmp/
RUN unzip /tmp/tools_r25.2.3-linux.zip -d /usr/local/android-sdk-linux
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK components

ONBUILD COPY android_sdk_components.env /android_sdk_components.env
ONBUILD RUN (while :; do echo 'y'; sleep 3; done) | android update sdk --no-ui --all --filter "$(cat /android_sdk_components.env)"

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS -Xms256m -Xmx512m

