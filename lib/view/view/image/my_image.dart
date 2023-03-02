import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:pet_charity/states/color_schemes.g.dart';

class MyImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const MyImage(this.url, {this.width, this.height, this.fit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == '') {
      return FlutterLogo(size: width);
    }
    return CachedNetworkImage(
      fit: fit,
      width: width,
      height: height,
      imageUrl: url,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
      },
      errorWidget: (context, url, error) => SvgPicture.asset(
        'assets/public/404.svg',
        colorFilter: const ColorFilter.mode(Colours.lilac, BlendMode.srcIn),
        width: width,
        height: height,
      ),
    );
  }
}
