import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../pages/accounts/role/role.dart';
import '../../pages/accounts/users/users.dart';
import '../../pages/booking/booking.dart';
import '../../pages/branches/branches.dart';
import '../../pages/cashflow/cashflow.dart';
import '../../pages/company/company.dart';
import '../../pages/company_info/company_info.dart';
import '../../pages/customers/customer.dart';
import '../../pages/dashboard/dash.dart';
import '../../pages/expenses/category/category.dart';
import '../../pages/expenses/entry/entry.dart';
import '../../pages/expenses/sub_category/sub_category.dart';
import '../../pages/income/category/category.dart';
import '../../pages/income/entry/entry.dart';
import '../../pages/income/sub_category/sub_category.dart';
import '../../pages/job_services/category/category.dart';
import '../../pages/job_services/entry/entry.dart';
import '../../pages/job_services/sub_category/sub_category.dart';
import '../../pages/login/controllers/binding.dart';
import '../../pages/login/login.dart';
import '../../pages/login/reset.dart';
import '../../pages/login/verify.dart';
import '../../pages/pos/main_pos.dart';
import '../../pages/service_report/service_report.dart';
import '../../pages/sms/sms.dart';
import '../../widgets/main_dash.dart';
import '../menu_controller/menu_controller.dart';

class Routes {
  static final routes = [
    GetPage(
      name: '/auth',
      page: () => const Login(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/service_category',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(
            panel: ServiceCategory(), selected: '/service_category'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/service_sub_category',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(
            panel: SSubCategory(), selected: '/service_sub_category'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/entry',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: ServiceEntry(), selected: '/entry'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/income_category',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child:
            const Framework(panel: InCategory(), selected: '/income_category'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/income_sub',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: InSubCategory(), selected: '/income_sub'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/income',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: InEntry(), selected: '/income'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/expenses_category',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child:
            const Framework(panel: ECategory(), selected: '/expenses_category'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/esub',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: ESubCategory(), selected: '/esub'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/expenses',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: EEntry(), selected: '/expenses'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/sms',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: SMS(), selected: '/sms'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/customer',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: Customer(), selected: '/customer'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/sales',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: MainPOS(), selected: '/sales'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/accounts',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: Users(), selected: '/accounts'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/sales_report',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: SReport(), selected: '/sales_report'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/bookings',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: Booking(), selected: '/bookings'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/branches',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: Branches(), selected: '/branches'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/cashflow',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: CashFlow(), selected: '/cashflow'),
      ),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/company',
      page: () => const Company(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/reset',
      page: () => const Reset(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/role',
      page: () => const Role(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/verify',
      page: () => const Verify(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/cinfo',
      page: () => const CompanyInfo(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/dash',
      page: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyMenuController(),
          ),
        ],
        child: const Framework(panel: Dash(), selected: '/dash'),
      ),
      binding: LoginBinding(),
    ),
  ];
}
