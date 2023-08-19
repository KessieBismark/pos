import 'package:flutter/material.dart';

import 'extension.dart';

class MyRichText extends StatelessWidget {
  // final Color mainColor;
  // final Color subColor;
  final TextStyle? mainStyle;
  final TextStyle? subStyle;
  final String mainText;
  final String subText;
  final bool? load;
  const MyRichText(
      {Key? key,
      // required this.mainColor,
      // required this.subColor,
      this.mainStyle,
      this.subStyle,
      required this.mainText,
      required this.subText,
      this.load})
      : super(key: key);

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: mainText,
          style: mainStyle,
          children: [TextSpan(text: subText, style: subStyle)],
        ),
      ).hPadding9;
}
