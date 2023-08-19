import 'package:get/get.dart';

import 'controller.dart';

class RoleBinding implements Bindings {
  @override
  void dependencies() {
    // Get.create<ShopsController>(() =>
    //    ShopsController()); // different instances for different list items

    Get.lazyPut(() => RoleController(), fenix: true);
    //Get.put<ShopsController>(ShopsController());
  }
}
