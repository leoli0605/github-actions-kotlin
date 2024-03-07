# 使用具有 Java 的基礎映像
FROM openjdk:17-bullseye

# 設定環境變數
ENV ANDROID_SDK_ROOT /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/build-tools/30.0.3

# 安裝必要的系統工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    curl

# 下載並解壓 Android SDK Command line tools
RUN mkdir -p /tmp/cmdline-tools \
    && curl -o cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip \
    && unzip cmdline-tools.zip -d /tmp/cmdline-tools \
    && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv /tmp/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm -rf /tmp/cmdline-tools \
    && rm cmdline-tools.zip

# 安裝 Android SDK 組件
RUN yes | sdkmanager --licenses && sdkmanager "platform-tools" "platforms;android-29" "build-tools;30.0.3"

# 安裝 Gradle
ENV GRADLE_VERSION 8.0
RUN curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-${GRADLE_VERSION}-bin.zip \
    && unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt \
    && rm gradle-${GRADLE_VERSION}-bin.zip
ENV PATH ${PATH}:/opt/gradle-${GRADLE_VERSION}/bin
