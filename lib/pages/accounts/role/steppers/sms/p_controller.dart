import 'package:get/get.dart';

import '../../../users/component/controllers/users_controller.dart';
UsersController user = Get.find();
class ProductionRoleController extends GetxController {
  var currentStep = 0.obs;
final setions = [
    'View Record',
    'Insert Record',
    'Update Record',
   
  ];

 final title = [
   'sms portal',
  ];

  void toggle2(int val, String name) {
  String id =   initials(name, val);
    if (user.permission.contains(id)) {
     user. permission.remove(id);
    } else {
     user. permission.add(id);
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
}
