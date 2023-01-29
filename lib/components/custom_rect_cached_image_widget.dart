import 'package:akwaaba/components/profile_shimmer_item.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CustomRectCachedImageWidget extends StatefulWidget {
  final String url;
  final double height;
  final double? width;
  final bool showProgressLoading;
  final fitType;

  const CustomRectCachedImageWidget(
      {required this.url,
      required this.height,
      this.showProgressLoading = true,
      this.width,
      this.fitType = 1,
      Key? key})
      : super(key: key);

  @override
  State<CustomRectCachedImageWidget> createState() =>
      _CustomRectCachedImageWidgetState();
}

class _CustomRectCachedImageWidgetState
    extends State<CustomRectCachedImageWidget> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: widget.width ?? widget.height,
      height: widget.height,
      fit: widget.fitType == 1 ? BoxFit.cover : BoxFit.contain,
      imageUrl: widget.url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          widget.showProgressLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: whiteColor,
                    ),
                  ),
                )
              //? CircularProgressIndicator(value: downloadProgress.progress)
              : Image.asset(
                  "images/placeholder.png",
                  width: widget.width ?? widget.height,
                  height: widget.height,
                  fit: BoxFit.cover,
                ),
      errorWidget: (context, url, error) => SvgPicture.asset(
        "images/illustrations/profile_pic.svg",
        width: widget.width ?? widget.height,
        height: widget.height,
        fit: BoxFit.cover,
      ),
    );
  }
}
