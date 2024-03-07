# Android App Development with Kotlin

本指南將帶領你完成使用 Kotlin 進行 Android 應用開發的基本流程，包括構建應用、生成密鑰庫、簽名應用、驗證簽名，以及對 APK 進行對齊的步驟。

## 開始之前

確保你的 Gradle 包裝器 (`gradlew`) 是可執行的。你可以使用以下指令透過 `Docker` 來建置環境。

```sh
docker build -t android-kotlin .
docker run -it --rm -v $(pwd):/app -w /app android-kotlin /bin/bash
```

或是直接執行 `./dockershell` 來進入容器。

然後構建整個項目，包括 Debug 和 Release 版本。

```sh
chmod +x gradlew
./gradlew build
./gradlew assembleDebug
./gradlew assembleRelease
```

## 生成密鑰庫

使用 `keytool` 生成密鑰庫和密鑰。

```sh
keytool -genkeypair -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

`-genkeypair` 表示生成一對公鑰和私鑰。`-v` 表示詳細模式。`-keystore my-release-key.keystore` 表示生成的密鑰庫的名稱。`-alias my-key-alias` 表示生成的密鑰的別名。`-keyalg RSA` 表示使用 RSA 算法生成密鑰。`-keysize 2048` 表示生成的密鑰的大小。`-validity 10000` 表示密鑰的有效期為 10000 天。

以下命令示例展示了如何提供 Distinguished Name (DN) 信息。

```sh
keytool -genkeypair -v \
        -keystore my-release-key.keystore \
        -alias my-key-alias \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -storepass <密鑰庫密碼> \
        -keypass <密鑰密碼> \
        -dname "CN=<你的名字>, OU=<你的組織單位>, O=<你的組織>, L=<你的城市>, S=<你的州或省>, C=<你的國家代碼>"
```

將 `<密鑰庫密碼>`、`<密鑰密碼>`、`<你的名字>`、`<你的組織單位>`、`<你的組織>`、`<你的城市>`、`<你的州或省>` 和 `<你的國家代碼>` 替換成你的實際資訊。

## 簽名你的應用

使用 `jarsigner` 為你的應用簽名。

```sh
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 -keystore my-release-key.keystore app/build/outputs/apk/release/app-release.apk my-key-alias
```

記得替換 `<密鑰庫密碼>` 和 `<密鑰密碼>` 為你的實際密碼。

## 驗證你的應用

確保你的應用已經被正確簽名。

```sh
jarsigner -verify -verbose -certs app/build/outputs/apk/release/app-release.apk
```

## 對齊你的應用

使用 `zipalign` 工具優化 APK，提高應用的運行效率。

```sh
zipalign -v 4 app/build/outputs/apk/release/app-release.apk app-release-aligned.apk
```
