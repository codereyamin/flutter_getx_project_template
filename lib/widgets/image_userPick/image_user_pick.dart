import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/constant/app_colors.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/utils/gap.dart';
import 'package:flutter_getx_project_template/widgets/app_snack_bar/app_snack_bar.dart';
import 'package:flutter_getx_project_template/widgets/texts/app_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void appImageUserTake({required RxString localImagePath, required Function() callBack}) {
  Get.bottomSheet(
    Container(
      margin: EdgeInsets.all(AppSize.height(value: 20.0)),
      padding: EdgeInsets.all(AppSize.height(value: 10.0)),
      decoration: BoxDecoration(color: AppColors.instance.white500, borderRadius: BorderRadius.circular(AppSize.width(value: 12.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(Get.context!);
              },
              icon: const Icon(Icons.close),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(Get.context!);
                    appUserImagePic(source: ImageSource.camera, localImagePath: localImagePath, callBack: callBack);
                  },
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt, size: 60, color: AppColors.instance.primary),
                      const AppText(data: "Camera", fontWeight: FontWeight.w700),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(Get.context!);

                    appUserImagePic(source: ImageSource.gallery, localImagePath: localImagePath, callBack: callBack);
                  },
                  child: Column(
                    children: [
                      Icon(Icons.collections, size: 60, color: AppColors.instance.primary),
                      const AppText(data: "Gallery", fontWeight: FontWeight.w700),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(height: 20),
        ],
      ),
    ),
  );
}

Future<void> appUserImagePic({required ImageSource source, required RxString localImagePath, required Function() callBack}) async {
  try {
    bool permissionGranted = false;

    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;
      if (status.isGranted || status.isLimited) {
        permissionGranted = true;
      }

      if (status.isDenied) {
        var response = await askFirst(
          title: "Camera Access Required",
          content: """We need access to your camera so you can update your profile picture""",
          acceptButton: "Allow Camera",
        );
        if (response) {
          final request = await Permission.camera.request();
          if (request.isGranted || request.isLimited) {
            permissionGranted = true;
          }
        }
      }

      if (status.isPermanentlyDenied) {
        var response = await getCallAgainPermission(
          title: "Camera Access Required",
          content: """We need access to your camera so you can update your profile picture""",
          acceptButton: "Allow Camera",
        );
        if (response) {
          final request = await Permission.camera.request();
          if (request.isGranted || request.isLimited) {
            permissionGranted = true;
          }
        }
      }
    } else {
      // Gallery access
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
            final request = await Permission.photos.request();

            if (request.isGranted || request.isLimited) {
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
            final request = await Permission.photos.request();
            if (request.isGranted || request.isLimited) {
              permissionGranted = true;
            }
          } else {
            return;
          }
        }
      } else if (Platform.isAndroid) {
        final status = await Permission.storage.status;
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
            final request = await Permission.storage.request();
            if (request.isGranted || request.isLimited) {
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
            final status = await Permission.storage.status;
            if (status.isGranted || status.isLimited) {
              permissionGranted = true;
            }
          }
        }
      }
    }

    if (permissionGranted) {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        localImagePath.value = picked.path;
        callBack();
      }
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
  String acceptButton = "Open Settings",
  String cancelButton = "Cancel",
}) async {
  bool userConfirmed = false;

  await Get.defaultDialog(
    title: title,
    content: Text(content, textAlign: TextAlign.center),
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
