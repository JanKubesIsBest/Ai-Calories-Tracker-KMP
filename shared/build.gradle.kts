import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)

    alias(libs.plugins.skie)

    alias(libs.plugins.kotlinx.serialization)
    alias(libs.plugins.sqldelight)
}

kotlin {
    androidTarget {
        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }
    
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach { iosTarget ->
        iosTarget.binaries.framework {
            baseName = "Shared"
            isStatic = true
        }
    }
    
    sourceSets {
        commonMain.dependencies {
            // put your Multiplatform dependencies here
            implementation(libs.kotlinx.coroutines.core)
            implementation(libs.androidx.lifecycle.viewmodel)
            implementation(libs.androidx.lifecycle.viewmodel.kmp)

            implementation(libs.ktor.client.core)
            implementation(libs.ktor.client.content.negotiation)
            implementation(libs.ktor.serialization.kotlinx.json)
            implementation(libs.kotlinx.datetime)
        }

        androidMain.dependencies {
            implementation(libs.ktor.client.okhttp)

            implementation(libs.android.driver)
        }

        iosMain.dependencies {
            implementation(libs.ktor.client.darwin)

            implementation(libs.native.driver)
        }
    }
}

android {
    namespace = "kubes.jan.gpt_calories_tracker.shared"
    compileSdk = libs.versions.android.compileSdk.get().toInt()
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    defaultConfig {
        minSdk = libs.versions.android.minSdk.get().toInt()
    }
}
dependencies {
    implementation(libs.identity.jvm)
    implementation(libs.androidx.ui.android)
}

skie {
    features {
        enableSwiftUIObservingPreview = true
    }
}

sqldelight {
    databases {
        create("AppDatabase") {
            packageName.set("kubes.jan.gpt_calories_tracker.cache")
        }
    }
}

