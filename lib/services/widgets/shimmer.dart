import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/color.dart';
import '../constants/constant.dart';

class ShimmerInfoCard extends StatelessWidget {
  final double height;
  final double width;
  final Widget widget;

  const ShimmerInfoCard({Key? key, required this.height, required this.width, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: mygrey,
        child: Container(
            height: height,
            width: myWidth(context, width),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 6),
                      color: lightGrey.withOpacity(.1),
                      blurRadius: 12)
                ],
                borderRadius: BorderRadius.circular(8)),
            child: Expanded(child: widget)),
      ),
    );
  }
}
