import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:get/get.dart';

void customDialogShow({required Widget dialogContent, EdgeInsets? insetPadding, void Function()? onTap}) {
  showDialog(
    context: Get.context!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap:
            onTap ??
            () {
              _closeDialog(context);
            },
        child: _CustomDialog(dialogContent: dialogContent),
      );
    },
  );
}

customDialogHide() {
  try {
    _closeDialog(Get.context!);
  } catch (e) {
    errorLog("customDialogHide", e);
  }
}

class _CustomDialog extends StatefulWidget {
  const _CustomDialog({required this.dialogContent});
  final Widget dialogContent;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

AnimationController? _animationController;
Animation<double>? _scaleAnimation;
bool _isDismissed = false;
Future<void> _closeDialog(BuildContext context) async {
  try {
    if (!_isDismissed) {
      _isDismissed = true;
      await _animationController!.reverse();
      if (context.mounted) Navigator.of(context).pop();
    }
  } catch (e) {
    errorLog("_closeDialog", e);
  }
}

class _CustomDialogState extends State<_CustomDialog> with TickerProviderStateMixin {
  onInitialDataSetUp() {
    try {
      _isDismissed = false;
      _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
      if (_animationController != null) {
        _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut));
        _animationController!.forward();
      }
    } catch (e) {
      errorLog("onInitialDataSetUp", e);
    }
  }

  @override
  void initState() {
    super.initState();
    onInitialDataSetUp();
  }

  onAppClose() {
    try {
      _animationController?.dispose();
    } catch (e) {
      errorLog("onAppClose", e);
    }
  }

  @override
  void dispose() {
    onAppClose();
    super.dispose();
  }

  Widget _buildDialogContent(BuildContext context) {
    return GestureDetector(
      onTap: () => _closeDialog(context),
      child: AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation!.value, child: widget.dialogContent);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.ease,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 15)),
      child: SizedBox(width: AppSize.size.width, height: AppSize.size.height, child: _buildDialogContent(context)),
    );
  }
}
