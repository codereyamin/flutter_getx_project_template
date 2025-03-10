import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_getx_project_template/constant/app_api_end_point.dart';
import 'package:flutter_getx_project_template/constant/app_assert_image.dart';
import 'package:flutter_getx_project_template/constant/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppImageCircular extends StatelessWidget {
  const AppImageCircular({
    super.key,
    this.color = Colors.blue,
    this.fit = BoxFit.cover,
    this.height,
    this.path,
    this.url,
    this.width,
    this.filePath,
    this.borderRadius = 100,
    this.filledColor,
    this.filledPadding,
  });
  final String? path;
  final String? filePath;
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color color;
  final Color? filledColor;
  final EdgeInsetsGeometry? filledPadding;

  @override
  Widget build(BuildContext context) {
    if (filePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: filledPadding,
          decoration: BoxDecoration(color: filledColor),
          child: Image.file(
            File(filePath!),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: Container(width: width, height: height, color: AppColors.instance.primary));
            },
          ),
        ),
      );
    }
    if (url != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: filledPadding,
          decoration: BoxDecoration(color: filledColor),
          child: NetworkImageWithRetry(imageUrl: url!, fit: fit, height: height, width: width, borderRadius: borderRadius),
        ),
      );
    }
    if (path != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: filledPadding,
          decoration: BoxDecoration(color: filledColor),
          child: Image.asset(
            path!,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: Container(width: width, height: height, color: AppColors.instance.primary));
            },
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(padding: filledPadding, decoration: BoxDecoration(color: filledColor), child: Container(width: width, height: height, color: color)),
    );
  }
}

class NetworkImageWithRetry extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double borderRadius;

  const NetworkImageWithRetry({super.key, required this.imageUrl, this.fit, this.height, this.width, required this.borderRadius});

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

  @override
  void didUpdateWidget(covariant NetworkImageWithRetry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl.hashCode != widget.key.hashCode) {
      retryCount = 0;
      _setImage();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    }
  }

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
    if (retryCount < maxRetries) {
      await Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          retryCount++;
        });
      });
    } else {
      log("Max retries reached for image: $_image");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: CachedNetworkImage(
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
      ),
    );
  }

  Widget _loadingPlaceholder() {
    return Skeletonizer(
      enabled: true,
      containersColor: AppColors.instance.blue2_50,
      child: Container(width: widget.width, height: widget.height, color: AppColors.instance.white300, child: Image.asset(AppAssertImage.instance.networkPlaceholderImage, fit: BoxFit.fill)),
    );
  }

  Widget _errorPlaceholder() {
    return Container(width: widget.width, height: widget.height, color: Colors.grey, child: const Center(child: Icon(Icons.image_not_supported)));
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
