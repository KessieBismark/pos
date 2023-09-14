import 'package:get/get.dart';

import '../../accounts/role/controller/controller.dart';
import '../../accounts/users/component/controllers/users_controller.dart';
import '../../booking/component/controler/controller.dart';
import '../../branches/component/controller/controller.dart';
import '../../cashflow/component/controller/controller.dart';
import '../../company/component/controller/controller.dart';
import '../../company_info/component/controller/controller.dart';
import '../../customers/component/controller/controller.dart';
import '../../dashboard/component/controller/controller.dart';
import '../../expenses/category/component/controller/controller.dart';
import '../../expenses/entry/component/controller/controller.dart';
import '../../expenses/sub_category/component/controller/controller.controller.dart';
import '../../income/category/component/controller/controller.dart';
import '../../income/entry/component/controller/controller.dart';
import '../../income/sub_category/component/controller/controller.controller.dart';
import '../../job_services/category/component/controller/controller.dart';
import '../../job_services/entry/component/controller/controller.dart';
import '../../job_services/sub_category/component/controller/controller.controller.dart';
import '../../pos/component/controller/controller.dart';
import '../../service_report/component/controller/controler.dart';
import '../../sms/component/controller/controller.dart';
import 'login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => ServiceCatCon());
    Get.lazyPut(() => SSCatCon());
    Get.lazyPut(() => DashCon());
    Get.lazyPut(() => ServiceEntryCon());
    Get.lazyPut(() => InCatCon());
    Get.lazyPut(() => ECatCon());
    Get.lazyPut(() => InSCatCon());
    Get.lazyPut(() => InEntryCon());
    Get.lazyPut(() => ESCatCon());
    Get.lazyPut(() => EEntryCon());
    Get.lazyPut(() => CustomerCon());
    Get.lazyPut(() => SmsCon());
    Get.lazyPut(() => POSCon());
    Get.lazyPut(() => UsersController());
    Get.lazyPut(() => CompanyCon());
    Get.lazyPut(() => CompanyInfoCon());
    Get.lazyPut(() => BranchesCon());
    Get.lazyPut(() => RoleController());
    Get.lazyPut(() => SRCon());
    Get.lazyPut(() => BookingCon());
    Get.lazyPut(() => CashFlowCon());
  }
}
