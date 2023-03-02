import 'package:flutter/material.dart';

typedef SliverHeaderBuilder = Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final SliverHeaderBuilder builder;

  // child 为 header
  SliverHeaderDelegate({required this.maxHeight, this.minHeight = 0, required Widget child})
      : builder = ((context, shrinkOffset, overlapsContent) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  // 最大和最小高度相同
  SliverHeaderDelegate.fixedHeight({required double height, required Widget child})
      : builder = ((context, shrinkOffset, overlapsContent) => child),
        maxHeight = height,
        minHeight = height;

  // 需要自定义builder时使用
  SliverHeaderDelegate.builder({required this.maxHeight, this.minHeight = 0, required this.builder});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
  }
}
