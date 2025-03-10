import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/constant/app_colors.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/utils/gap.dart';
import 'package:flutter_getx_project_template/widgets/app_snack_bar/app_snack_bar.dart';
import 'package:flutter_getx_project_template/widgets/texts/app_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore_for_file: file_names
Future<void> appUserImagePic({required ImageSource source, required RxString localImagePath, required Function() callBack}) async {
  try {
    XFile? pickedField;
    if (source == ImageSource.camera) {
      var cameraStatus = await Permission.camera.status;

      if (cameraStatus.isGranted) {
        pickedField = await ImagePicker().pickImage(source: source);
      } else if (cameraStatus.isDenied) {
        var cameraStatus2 = await Permission.camera.request();
        if (cameraStatus2.isGranted) {
          pickedField = await ImagePicker().pickImage(source: source);
        } else {
          AppSnackBar.error("Camera Permission Needed");
          return;
        }
      } else if (cameraStatus.isRestricted) {
        AppSnackBar.error("Camera Permission Restricted");
        return;
      }
    } else {
      var mediaLibraryStatus = await Permission.mediaLibrary.status;
      var mediaStorageStatus = await Permission.manageExternalStorage.status;

      if (mediaLibraryStatus.isGranted || mediaStorageStatus.isGranted) {
        pickedField = await ImagePicker().pickImage(source: source);
      } else {
        var mediaLibraryStatus2 = await Permission.mediaLibrary.request();
        var mediaStorageStatus2 = await Permission.manageExternalStorage.request();

        if (mediaLibraryStatus2.isGranted || mediaStorageStatus2.isGranted) {
          pickedField = await ImagePicker().pickImage(source: source);
        } else {
          AppSnackBar.error("Media Permission Needed");
          return;
        }
      }
    }

    if (pickedField != null) {
      localImagePath.value = pickedField.path;
      callBack();
    }
  } catch (e) {
    AppSnackBar.error("Something Was Wrong");
  }
}

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
                  child: Column(children: [Icon(Icons.camera_alt, size: 60, color: AppColors.instance.primary), const AppText(data: "Camera", fontWeight: FontWeight.w700)]),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(Get.context!);

                    appUserImagePic(source: ImageSource.gallery, localImagePath: localImagePath, callBack: callBack);
                  },
                  child: Column(children: [Icon(Icons.collections, size: 60, color: AppColors.instance.primary), const AppText(data: "Gallery", fontWeight: FontWeight.w700)]),
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
