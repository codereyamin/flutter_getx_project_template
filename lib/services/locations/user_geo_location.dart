import 'package:beauty_service/utils/error_log.dart';
import 'package:beauty_service/widgets/app_snack_bar/app_snack_bar.dart';
import 'package:beauty_service/widgets/texts/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';

Future<Position?> appUserGeoLocation() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;
    late LocationSettings locationSettings;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppSnackBar.error("Your device has no GPS services");
      return null;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      var response = await getCallAgainPermission();
      if (response) {
        return await appUserGeoLocation();
      }
      return null;
    }

    if (permission == LocationPermission.denied) {
      var response = await firstAskPermission();
      if (!response) {
        return null;
      }
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        return null;
      }
    }

    /////////////////  location settings
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        //(Optional) Set foreground notification config to keep the app alive
        //when going to the background
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Ooh Ah will continue to receive your location even when you using it",
          notificationTitle: "Location Service",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else if (kIsWeb) {
      locationSettings = WebSettings(accuracy: LocationAccuracy.high, distanceFilter: 100, maximumAge: const Duration(minutes: 5));
    } else {
      locationSettings = const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  } catch (e) {
    errorLog("appUserGeoLocation", e);
    // AppSnackBar.error("Location services has problem ");
    return null;
  }
}

Future<bool> getCallAgainPermission({
  String title = "Permission Required",
  String content = """We Use Your Location to Improve Matching

To help you find nearby artists and users relevant to your preferences, we use your location. This allows us to match you with people and services close to you for a better, faster experience.

We respect your privacy and only use your location when necessary for this feature.""",
}) async {
  bool userConfirmed = false;

  await Get.defaultDialog(
    title: title,
    content: AppText(data: content, textAlign: TextAlign.center),
    radius: 8,
    confirm: ElevatedButton(
      onPressed: () async {
        userConfirmed = true;
        Get.closeAllDialogs();
      },
      child: const AppText(data: "Allow Location"),
    ),
    cancel: TextButton(
      onPressed: () {
        userConfirmed = false;
        Get.closeAllDialogs();
      },
      child: const AppText(data: "Cancel"),
    ),
  );

  if (userConfirmed) {
    await Geolocator.openAppSettings();
  }

  return userConfirmed;
}

Future<bool> firstAskPermission({
  String title = "Permission Required",
  String content = """We Use Your Location to Improve Matching

To help you find nearby artists and users relevant to your preferences, we use your location. This allows us to match you with people and services close to you for a better, faster experience.

We respect your privacy and only use your location when necessary for this feature.""",
}) async {
  bool userConfirmed = false;

  await Get.defaultDialog(
    title: title,
    content: AppText(data: content, textAlign: TextAlign.center),
    radius: 8,
    confirm: ElevatedButton(
      onPressed: () async {
        userConfirmed = true;
        Get.closeAllDialogs();
      },
      child: const AppText(data: "Allow Location"),
    ),
    cancel: TextButton(
      onPressed: () {
        userConfirmed = false;
        Get.closeAllDialogs();
      },
      child: const AppText(data: "Cancel"),
    ),
  );
  return userConfirmed;
}
