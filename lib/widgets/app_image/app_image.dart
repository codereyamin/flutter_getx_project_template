import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_getx_project_template/constant/app_api_end_point.dart';
import 'package:flutter_getx_project_template/constant/app_assert_image.dart';
import 'package:flutter_getx_project_template/constant/app_colors.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.color,
    this.fit = BoxFit.cover,
    this.height,
    this.path,
    this.url,
    this.width,
    this.filePath,
    this.iconColor,
    this.isZomBle = false,
    this.placeholder,
    this.networkPlaceholderImage,
  });

  final String? path;
  final String? networkPlaceholderImage;
  final String? filePath;
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final double? placeholder;
  final Color? color;
  final Color? iconColor;
  final bool isZomBle;

  @override
  Widget build(BuildContext context) {
    // File image
    if (filePath != null) {
      return GestureDetector(
        onTap:
            isZomBle
                ? () {
                  if (isZomBle) {
                    _showFullScreenImage(
                      context,
                      Image.file(
                        File(filePath!),
                        width: width,
                        height: height,
                        fit: fit,
                        errorBuilder: (context, error, stackTrace) {
                          log("Error loading file image: $error");
                          return _errorPlaceholder();
                        },
                      ),
                    );
                  }
                }
                : null,
        child: Image.file(
          File(filePath!),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            log("Error loading file image: $error");
            return _errorPlaceholder();
          },
        ),
      );
    }

    // Network image
    if (url != null && url!.isNotEmpty) {
      return GestureDetector(
        onTap:
            isZomBle
                ? () {
                  if (isZomBle) {
                    _showFullScreenImage(context, NetworkImageWithRetry(key: UniqueKey(), imageUrl: url!, width: width, height: height, fit: fit));
                  }
                }
                : null,
        child: NetworkImageWithRetry(key: UniqueKey(), imageUrl: url!, width: width, height: height, fit: fit),
      );
    }

    // Asset image
    if (path != null) {
      return GestureDetector(
        onTap:
            isZomBle
                ? () {
                  if (isZomBle) {
                    _showFullScreenImage(
                      context,
                      Image.asset(
                        path!,
                        width: width,
                        height: height,
                        fit: fit,
                        color: iconColor,
                        errorBuilder: (context, error, stackTrace) {
                          log("Error loading asset image: $error");
                          return _errorPlaceholder();
                        },
                      ),
                    );
                  }
                }
                : null,
        child: Image.asset(
          path!,
          width: width,
          height: height,
          fit: fit,
          color: iconColor,
          errorBuilder: (context, error, stackTrace) {
            log("Error loading asset image: $error");
            return _errorPlaceholder();
          },
        ),
      );
    }

    // Default placeholder
    return Container(
      width: width,
      height: height,
      color: color ?? AppColors.instance.white200,
      child: Image.asset(
        networkPlaceholderImage ?? AppAssertImage.instance.networkPlaceholderImage,
        width: width,
        height: height,
        fit: fit,
        color: iconColor,
        errorBuilder: (context, error, stackTrace) {
          log("Error loading asset image: $error");
          return _errorPlaceholder();
        },
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(width: width, height: height, color: color, child: const Center(child: Icon(Icons.image_not_supported)));
  }

  void _showFullScreenImage(BuildContext context, Widget imageWidget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImageViewer(image: imageWidget)));
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final Widget image;

  const FullScreenImageViewer({super.key, required this.image});

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Animation<Matrix4>? zoomAnimation;
  late TransformationController transformationController;
  TapDownDetails? doubleTapDetails;
  void onAppInitial() {
    try {
      transformationController = TransformationController();

      animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..addListener(() {
        transformationController.value = zoomAnimation!.value;
      });
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  void handleDoubleTapDown(TapDownDetails details) {
    doubleTapDetails = details;
  }

  void handleDoubleTap() {
    final newValue = transformationController.value.isIdentity() ? _applyZoom() : _revertZoom();

    zoomAnimation = Matrix4Tween(begin: transformationController.value, end: newValue).animate(CurveTween(curve: Curves.ease).animate(animationController));
    animationController.forward(from: 0);
  }

  Matrix4 _applyZoom() {
    final tapPosition = doubleTapDetails!.localPosition;
    const translationCorrection = 2 - 1; // This is effectively 1, which can be removed for clarity.
    final zoomed =
        Matrix4.identity()
          ..translate(-tapPosition.dx * translationCorrection, -tapPosition.dy * translationCorrection)
          ..scale(2.0); // Ensure you pass a double value for the scaling factor.
    return zoomed;
  }

  Matrix4 _revertZoom() => Matrix4.identity();

  appClose() {
    try {
      transformationController.dispose();
      animationController.dispose();
    } catch (e) {
      errorLog("appClose", e);
    }
  }

  @override
  void initState() {
    onAppInitial();
    super.initState();
  }

  @override
  void dispose() {
    appClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, elevation: 0, leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(context).pop())),
      body: GestureDetector(
        onDoubleTapDown: handleDoubleTapDown,
        onDoubleTap: handleDoubleTap,
        child: InteractiveViewer(transformationController: transformationController, child: Center(child: widget.image)),
      ),
    );
  }
}

class NetworkImageWithRetry extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const NetworkImageWithRetry({super.key, required this.imageUrl, this.fit, this.height, this.width});

  @override
  State<NetworkImageWithRetry> createState() => _NetworkImageWithRetryState();
}

class _NetworkImageWithRetryState extends State<NetworkImageWithRetry> with AutomaticKeepAliveClientMixin {
  int retryCount = 0;
  final int maxRetries = 2;
  late String _image;

  @override
  void initState() {
    _setImage();
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant NetworkImageWithRetry oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.imageUrl != widget.key.hashCode) {
  //     retryCount = 0;
  //     _setImage();
  //     WidgetsBinding.instance.addPostFrameCallback(
  //       (timeStamp) {
  //         setState(() {});
  //       },
  //     );
  //   }
  // }

  void _setImage() {
    try {
      final uri = Uri.tryParse(widget.imageUrl);
      if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
        _image = widget.imageUrl;
      } else {
        // _image = "${AppApiEndPoint.instance.domain}${widget.imageUrl}";
        _image = "${AppApiEndPoint.instance.domain}${widget.imageUrl}";
      }
    } catch (e) {
      log("Error setting image URL: $e");
      _image = widget.imageUrl;
    }
  }

  void _retry() async {
    try {
      if (retryCount < maxRetries) {
        await Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            setState(() {
              retryCount++;
            });
          }
        });
      } else {
        log("Max retries reached for image: $_image");
      }
    } catch (e) {
      errorLog("_retry", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CachedNetworkImage(
      cacheManager: CustomCacheManager.instance,
      imageUrl: optimizedImageUrl(_image),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: const Duration(milliseconds: 100),
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => _loadingPlaceholder(),
      errorWidget: (context, url, error) {
        _retry();
        return _errorPlaceholder();
      },
    );
  }

  Widget _loadingPlaceholder() {
    return Skeletonizer(
      enabled: true,
      containersColor: AppColors.instance.blue2_50,
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height,
        color: AppColors.instance.white300,
        child: Image.asset(AppAssertImage.instance.networkPlaceholderImage, fit: BoxFit.fill),
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(width: widget.width, height: widget.height, color: AppColors.instance.primary50, child: Center(child: Icon(Icons.image_not_supported, color: AppColors.instance.primary50)));
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomCacheManager extends CacheManager {
  static const key = "optimizedCache";

  static final CustomCacheManager instance = CustomCacheManager._();

  CustomCacheManager._() : super(Config(key, stalePeriod: const Duration(days: 7), maxNrOfCacheObjects: 300, repo: JsonCacheInfoRepository(databaseName: key), fileService: HttpFileService()));
}

String optimizedImageUrl(String url, {int width = 600, int height = 600}) {
  return "$url?width=$width&height=$height";
}
