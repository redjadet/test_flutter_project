plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ilkersevim.complex_ui"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ilkersevim.complex_ui"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += listOf("env")

    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "ComplexUI-Dev")
            manifestPlaceholders["appLabel"] = "ComplexUI-Dev"
            manifestPlaceholders["appIcon"] = "ic_launcher_dev"
            manifestPlaceholders["appIconRound"] = "ic_launcher_dev_round"
            signingConfig = signingConfigs.getByName("dev")
        }
        create("test") {
            dimension = "env"
            applicationIdSuffix = ".test"
            versionNameSuffix = "-test"
            resValue("string", "app_name", "ComplexUI-Test")
            manifestPlaceholders["appLabel"] = "ComplexUI-Test"
            manifestPlaceholders["appIcon"] = "ic_launcher_test"
            manifestPlaceholders["appIconRound"] = "ic_launcher_test_round"
            signingConfig = signingConfigs.getByName("test")
        }
        create("prod") {
            dimension = "env"
            // No suffix for prod
            resValue("string", "app_name", "ComplexUI")
            manifestPlaceholders["appLabel"] = "ComplexUI"
            manifestPlaceholders["appIcon"] = "ic_launcher"
            manifestPlaceholders["appIconRound"] = "ic_launcher_round"
            signingConfig = signingConfigs.getByName("prod")
        }
    }

    signingConfigs {
        create("dev") {
            val propsFile = rootProject.file("android/keystore/dev.properties")
            if (propsFile.exists()) {
                val props = java.util.Properties().apply { load(propsFile.inputStream()) }
                storeFile = file(props["storeFile"] ?: "")
                storePassword = props["storePassword"] as String?
                keyAlias = props["keyAlias"] as String?
                keyPassword = props["keyPassword"] as String?
            }
        }
        create("test") {
            val propsFile = rootProject.file("android/keystore/test.properties")
            if (propsFile.exists()) {
                val props = java.util.Properties().apply { load(propsFile.inputStream()) }
                storeFile = file(props["storeFile"] ?: "")
                storePassword = props["storePassword"] as String?
                keyAlias = props["keyAlias"] as String?
                keyPassword = props["keyPassword"] as String?
            }
        }
        create("prod") {
            val propsFile = rootProject.file("android/keystore/release.properties")
            if (propsFile.exists()) {
                val props = java.util.Properties().apply { load(propsFile.inputStream()) }
                storeFile = file(props["storeFile"] ?: "")
                storePassword = props["storePassword"] as String?
                keyAlias = props["keyAlias"] as String?
                keyPassword = props["keyPassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            // Default to debug signing when no keystore provided; flavors may override.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

afterEvaluate {
    android.applicationVariants.all {
        val flavor = this.flavorName
        val target = when (flavor) {
            "dev" -> "lib/main_dev.dart"
            "test" -> "lib/main_test.dart"
            "prod" -> "lib/main_prod.dart"
            else -> null
        }
        if (target != null) {
            project.extensions.extraProperties.set("target", target)
        }
    }
}
