plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.lucasgoudin.mobichan"
    compileSdk = 36
    // Align with plugin-required NDK version
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required for libraries needing Java 8+ desugaring (e.g., flutter_local_notifications)
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
        // Kotlin performance optimizations
        freeCompilerArgs += listOf(
            "-opt-in=kotlin.RequiresOptIn",
            "-Xjvm-default=all"
        )
    }

    defaultConfig {
        applicationId = "com.lucasgoudin.mobichan"
        // Android 9+ for modern ART JIT/AOT optimizations and better performance
        minSdk = 28
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Native library optimizations
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        }
    }

    buildTypes {
        release {
            // Use debug signing temporarily; replace with release config when keys are available.
            signingConfig = signingConfigs.getByName("debug")

            // Maximum code optimization
            isMinifyEnabled = true
            isShrinkResources = true

            // R8 full mode for better optimization
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )

            // Performance optimizations
            isDebuggable = false
            isJniDebuggable = false
            isRenderscriptDebuggable = false
            isPseudoLocalesEnabled = false
            isCrunchPngs = true
        }
        debug {
            // Keep debug builds fast; no shrinking.
        }
    }

    // Performance: use non-transitive R classes
    buildFeatures {
        buildConfig = true
    }

    packaging {
        resources {
            excludes += setOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/license.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/notice.txt",
                "META-INF/*.kotlin_module"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Desugaring library to support Java 8+ APIs on older Android devices
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
