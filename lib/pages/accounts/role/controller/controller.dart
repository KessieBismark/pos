import 'dart:convert';

import 'package:get/get.dart';

import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import '../../users/component/controllers/users_controller.dart';

final user = Get.find<UsersController>();

class RoleController extends GetxController {
  var currentStep = 0.obs;
  String uId = Get.arguments;
  var isSaving = false.obs;
  String name = user.userName;

  @override
  void onInit() {
    super.onInit();
    Utils.checkAccess();
  }

  insert() async {
    isSaving.value = true;
    try {
      var data = {
        "action": "assign_role",
        "permission": user.permission.join(",").trim().toString(),
        "u_id": uId
      };
      var val = await Query.queryData(data);
      if (jsonDecode(val) == "true") {
        isSaving.value = false;
        Utils().showInfo("Access privileges has been updated successfully");
      } else {
        isSaving.value = false;
        Utils().showError("Something went wrong, could not save data");
      }
    } catch (e) {
      isSaving.value = false;
      print.call(e.toString());
      Utils().showError(e.toString());
    }
  }

  @override
  void onClose() {}
}
