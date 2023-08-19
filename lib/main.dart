import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'services/config/routes.dart';
import 'services/utils/themes.dart';

void main() async {
  await GetStorage.init();
  ThemeController thenmes = Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sales PO',
      theme: lightTheme,
      darkTheme: darkTheme,
      getPages: Routes.routes,
      themeMode: ThemeMode.system,
      initialRoute: '/auth',
      defaultTransition: Transition.fadeIn,
    );
  }
}
