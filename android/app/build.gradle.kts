import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("sh.measure.android.gradle") version "0.14.0"
}

/** Root `.env` → map (strip surrounding quotes). */
val dotenv = Properties().apply {
    val dotenvFile = rootProject.file("../.env")
    if (dotenvFile.exists()) {
        dotenvFile.reader(Charsets.UTF_8).use { load(it) }
        stringPropertyNames().toList().forEach { key ->
            val value = getProperty(key) ?: return@forEach
            if ((value.startsWith("'") && value.endsWith("'")) ||
                (value.startsWith("\"") && value.endsWith("\""))
            ) {
                setProperty(key, value.substring(1, value.length - 1))
            }
        }
    }
}

fun env(key: String, fallback: String = ""): String =
    dotenv.getProperty(key)?.trim().orEmpty().ifEmpty { fallback }

android {
    namespace = "com.blob.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Match Flutter/AGP Kotlin default (21); mismatch fails assemble*Kotlin.
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    defaultConfig {
        applicationId = "com.mamajees.blob.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["appAuthRedirectScheme"] = "com.mamajees.blob.app"
        manifestPlaceholders["measureApiUrl"] = env("PROD_MEASURE_API_URL")
        manifestPlaceholders["measureApiKey"] = env("PROD_MEASURE_API_KEY_ANDROID")
    }

    buildFeatures {
        resValues = true
    }

    flavorDimensions += "default"
    productFlavors {
        create("dev") {
            dimension = "default"
            applicationId = "com.mamajees.blob.app.dev"
            resValue("string", "app_name", "BLOB Dev")
            manifestPlaceholders["appAuthRedirectScheme"] = "com.mamajees.blob.app.dev"
            manifestPlaceholders["measureApiUrl"] = env("DEV_MEASURE_API_URL")
            manifestPlaceholders["measureApiKey"] = env("DEV_MEASURE_API_KEY_ANDROID")
        }
        create("prod") {
            dimension = "default"
            applicationId = "com.mamajees.blob.app"
            resValue("string", "app_name", "BLOB")
            manifestPlaceholders["appAuthRedirectScheme"] = "com.mamajees.blob.app"
            manifestPlaceholders["measureApiUrl"] = env("PROD_MEASURE_API_URL")
            manifestPlaceholders["measureApiKey"] = env("PROD_MEASURE_API_KEY_ANDROID")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21)
    }
}

flutter {
    source = "../.."
}
