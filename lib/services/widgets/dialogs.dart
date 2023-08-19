import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constant.dart';

class Dialogs {
  static dialog(context, String title, bool lock,double? height, double? width, Widget content,
      ) {
    return Get.defaultDialog(
        barrierDismissible: lock,
        title: title,
        content: height != 0.0 || width != 0.0
            ? SizedBox(
                height: myHeight(context, height),
                width: screenWidth(context) * 0.3 < 350
                    ? 350
                    : myWidth(context, width),
                child: content)
            : content);
  }
}
