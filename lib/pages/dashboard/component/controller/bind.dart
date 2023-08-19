import 'package:get/get.dart';

import 'controller.dart';

class DashBind implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashCon());
  }
}
