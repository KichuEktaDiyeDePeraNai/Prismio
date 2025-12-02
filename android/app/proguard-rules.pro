# Flutter-specific ProGuard rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Flutter model classes
-keep class io.flutter.plugins.** { *; }

# Keep your app's classes
-keep class com.example.test.** { *; }

# Keep Google Play Core
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Remove unused resources
-dontwarn java.lang.invoke.**
-dontwarn sun.misc.Unsafe

# Optimization settings
-optimizationpasses 5
-dontusemixedcaseclassnames
-verbose

# Keep model classes and annotations
-keepattributes *Annotation*
-keepattributes Signature

