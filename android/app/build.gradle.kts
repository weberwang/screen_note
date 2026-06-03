plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.screen_note"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications 20.x 依赖 Java 8+ API 回移支持，
        // 即使当前未直接使用定时通知，也需要在应用模块显式开启 desugaring。
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.screen_note"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

configurations.configureEach {
    resolutionStrategy.eachDependency {
        // home_widget 0.9.1 使用 1.+ 浮动版本，会把 Glance 解析到 1.3.0-alpha01，
        // 该版本要求 compileSdk 37 和 AGP 9.1+，与当前 Flutter Android 工具链不兼容。
        if (requested.group == "androidx.glance") {
            useVersion("1.2.0-rc01")
            because("锁定到与 compileSdk 36 / AGP 8.9.1 兼容的 Glance 版本")
        }
    }
}

dependencies {
    // 与 flutter_local_notifications 官方 20.x Gradle 配置保持一致。
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
