import 'package:flutter/material.dart';

import 'package:pet_charity/view/view/image/my_image.dart';

class ClipImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double size;
  final String? tag;
  final double? radius;
  final BoxFit? fit;
  final Color? bgColor;

  const ClipImage(this.url, {this.size = 32, this.width, this.height, this.tag, this.radius, this.fit, this.bgColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tag == null ? _buildContainer(context) : Hero(tag: tag!, child: _buildContainer(context));
  }

  Widget _buildContainer(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? size / 2),
      child: bgColor != null ? Container(color: bgColor, child: _myImage()) : _myImage(),
    );
  }

  MyImage _myImage() => MyImage(url, width: width ?? size, height: height ?? size, fit: fit ?? BoxFit.cover);
}
