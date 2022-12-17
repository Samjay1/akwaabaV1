import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomCachedImageWidget extends StatefulWidget {
  final String url;
  final double height;
  final width;
  final bool showProgressLoading;
  final fitType;


  const CustomCachedImageWidget({
       required this.url,
        required this.height,
        this.showProgressLoading=true,
        this.width,
        this.fitType=1,
        Key? key}) : super(key: key);

  @override
  State<CustomCachedImageWidget> createState() => _CustomCachedImageWidgetState();
}

class _CustomCachedImageWidgetState extends State<CustomCachedImageWidget> {
  @override
  Widget build(BuildContext context) {

    debugPrint("Image profile url ${widget.url}");
    return  CachedNetworkImage(
      width:widget.width ?? widget.height,
      height: widget.height,
      fit:widget.fitType==1?BoxFit.cover:BoxFit.contain,
      imageUrl:  widget.url,

      progressIndicatorBuilder: (context, url, downloadProgress) =>
      widget.showProgressLoading?
      CircularProgressIndicator(value: downloadProgress.progress):
      SvgPicture.asset("images/illustrations/profile_pic.svg",
        width:widget.width ?? widget.height, height: widget.height,
        fit: BoxFit.cover,),

      errorWidget: (context, url, error) =>
      // Text("Error")
      //
      SvgPicture.asset("images/illustrations/profile_pic.svg",
            width:widget.width ?? widget.height, height: widget.height,
          fit: BoxFit.cover,)
      ,
    );
  }
}
