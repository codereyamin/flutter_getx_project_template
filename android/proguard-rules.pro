# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Keep Flutter's JNI (Java Native Interface) bindings
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**



# Keep Unique App ID (Change "com.example_app" to your real package name)
-keep class com.example.flutter_getx_project_template.** { *; }





# Glide (for image loading)
-keep class com.bumptech.glide.** { *; }
-keepattributes *Annotation*
-dontwarn com.bumptech.glide.**

# Prevent stripping of Keep annotations
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations

# Keep Parcelable objects (important for passing data in intents)
-keep class * implements android.os.Parcelable { *; }

# Keep classes that use reflection
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Avoid warnings for missing classes
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.**
-dontwarn org.intellij.lang.annotations.**

# Optimize & Remove Unused Code
-optimizationpasses 10
-dontusemixedcaseclassnames
-dontpreverify
-allowaccessmodification
