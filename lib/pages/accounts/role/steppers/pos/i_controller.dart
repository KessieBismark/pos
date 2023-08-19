import 'package:get/get.dart';

import '../../../users/component/controllers/users_controller.dart';

UsersController user = Get.find();

class InventoryRoleController extends GetxController {
  var currentStep = 0.obs;

  void toggle2(int val, String name) {
    String id = initials(name, val);
    if (user.permission.contains(id)) {
      user.permission.remove(id);
    } else {
      user.permission.add(id);
    }
  }

  initials(String val, int num) {
    List<String> spliter = val.split(" ");
    String label = '';
    for (int i = 0; i < spliter.length; i++) {
      label = label + spliter[i].trim()[0].toUpperCase();
    }
    label = label + num.toString();
    return label;
  }

  final title = [
    'Pending Sales',
    'sales',
    'sales report',
  ];

  final setions = ['View Record', 'Make Sales', 'Make Bookings'];
}
