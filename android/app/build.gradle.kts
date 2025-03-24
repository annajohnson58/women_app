plugins {
    id("com.android.application")
    
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    compileSdk = 35 // Use '=' instead of 'compileSdkVersion'
    namespace = "com.example.women_app"
    ndkVersion = "29.0.13113456"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.women_app" // Ensure this is unique
        // minSdk = flutter.minSdkVersion
        minSdkVersion(23)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.10.0"))
    implementation("com.google.firebase:firebase-analytics")

    // ✅ Move desugaring dependency here
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
