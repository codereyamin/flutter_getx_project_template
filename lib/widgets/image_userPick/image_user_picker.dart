import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/widgets/app_snack_bar/app_snack_bar.dart';
import 'package:flutter_getx_project_template/widgets/texts/app_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> userImagePicker({required Function(List<String>) callBack}) async {
  try {
    List<XFile> pickedMedia = [];
    List<String> localImagePaths = [];

    bool permissionGranted = false;

    if (Platform.isIOS) {
      final status = await Permission.photos.status;
      if (status.isGranted || status.isLimited) {
        permissionGranted = true;
      }

      if (status.isDenied) {
        var response = await askFirst(
          acceptButton: "Allow Access",
          title: "Allow Access to Photos and Media",
          content: """Allow Access to Photos and Media

We need access to your device's media library so you can select photos, videos, or files, like updating your profile picture or uploading documents.

Your data is never shared and stays on your device unless you choose to upload it.""",
        );
        if (response) {
          final requestResult = await Permission.photos.request();
          if (requestResult.isGranted || requestResult.isLimited) {
            permissionGranted = true;
          }
        }
      }

      if (status.isPermanentlyDenied) {
        var response = await getCallAgainPermission(
          acceptButton: "Open Settings",
          title: "Allow Access to Photos and Media",
          content: """Allow Access to Photos and Media

We need access to your device's media library so you can select photos, videos, or files, like updating your profile picture or uploading documents.

Your data is never shared and stays on your device unless you choose to upload it.""",
        );
        if (response) {
          final storageStatus = await Permission.storage.status;
          if (storageStatus.isGranted || storageStatus.isLimited) {
            permissionGranted = true;
          }
        } else {
          return;
        }
      }
    } else if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.status;
      if (storageStatus.isGranted || storageStatus.isLimited) {
        permissionGranted = true;
      }

      if (storageStatus.isDenied) {
        var response = await askFirst(
          acceptButton: "Allow Access",
          title: "Allow Access to Photos and Media",
          content: """Allow Access to Photos and Media

We need access to your device's media library so you can select photos, videos, or files, like updating your profile picture or uploading documents.

Your data is never shared and stays on your device unless you choose to upload it.""",
        );
        if (response) {
          final requestResult = await Permission.storage.request();
          if (requestResult.isGranted || requestResult.isLimited) {
            permissionGranted = true;
          }
        }
      }

      if (storageStatus.isPermanentlyDenied) {
        var response = await getCallAgainPermission(
          acceptButton: "Open Settings",
          title: "Allow Access to Photos and Media",
          content: """Allow Access to Photos and Media

We need access to your device's media library so you can select photos, videos, or files, like updating your profile picture or uploading documents.

Your data is never shared and stays on your device unless you choose to upload it.""",
        );
        if (response) {
          final storageStatus = await Permission.storage.status;
          if (storageStatus.isGranted || storageStatus.isLimited) {
            permissionGranted = true;
          }
        } else {
          return;
        }
      }
    }

    if (permissionGranted) {
      pickedMedia = await ImagePicker().pickMultipleMedia(limit: 10);

      if (pickedMedia.isEmpty) {
        return;
      }

      localImagePaths = pickedMedia.map((xfile) => File(xfile.path).path).toList();

      callBack(localImagePaths);
    }
  } catch (e) {
    AppSnackBar.error("Something went wrong: ${e.toString()}");
  }
}

Future<bool> askFirst({
  String title = "Gallery",
  String content = "This permission is required to continue. Please enable it from settings.",
  String acceptButton = "Open Settings",
  String cancelButton = "Cancel",
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
      child: AppText(data: acceptButton),
    ),
    cancel: TextButton(
      onPressed: () {
        userConfirmed = false;
        Get.closeAllDialogs();
      },
      child: AppText(data: cancelButton),
    ),
  );
  return userConfirmed;
}

Future<bool> getCallAgainPermission({
  String title = "Gallery",
  String content = "This permission is required to continue. Please enable it from settings.",
  String acceptButton = "",
  String cancelButton = "Cancel",
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
      child: AppText(data: acceptButton),
    ),
    cancel: TextButton(
      onPressed: () {
        userConfirmed = false;
        Get.closeAllDialogs();
      },
      child: AppText(data: cancelButton),
    ),
  );

  if (userConfirmed) {
    await openAppSettings();
  }

  return userConfirmed;
}
