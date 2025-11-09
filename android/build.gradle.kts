// android/build.gradle.kts
plugins {
    id("com.android.application") apply false // keep your AGP version
    id("com.android.library") apply false     // keep if present
    // Add this line (version can be 4.4.x or newer supported):
    id("com.google.gms.google-services") apply false
    id("org.jetbrains.kotlin.android") apply false
}


allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
