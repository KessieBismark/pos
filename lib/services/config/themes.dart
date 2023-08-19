import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helpers.dart';

class ThemeController extends GetxController {
  // final _isLightTheme = false.obs;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  saveThemeStatus() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', Utils.isLightTheme.value);
  }

  _getThemeStatus() async {
    var isLight = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme') ?? true;
    }).obs;

    Utils.isLightTheme.value = await isLight.value;

    Get.changeThemeMode(
        Utils.isLightTheme.value ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  void onInit() {
    _getThemeStatus();
    super.onInit();
  }
}

// ThemeData lightTheme = ThemeData.light().copyWith(
//   scaffoldBackgroundColor: mygrey,
//   canvasColor: mygrey,
//   pageTransitionsTheme: const PageTransitionsTheme(builders: {
//     TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
//     TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
//     TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder()
//   }),
// );

// ThemeData darkTheme = ThemeData.dark().copyWith(
//   scaffoldBackgroundColor: dark,
//   // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//   //     .apply(bodyColor: dark),
//   canvasColor: secondaryColor,
//   pageTransitionsTheme: const PageTransitionsTheme(builders: {
//     TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
//     TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
//     TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder()
//   }),
// );


// class Themes() {
//   final lightTheme = ThemeData.light().copyWith(
//     scaffoldBackgroundColor: mygrey,
//     // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//     //     .apply(bodyColor: dark),
//     canvasColor: mygrey,
//     pageTransitionsTheme: const PageTransitionsTheme(builders: {
//       TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
//       TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
//     }),
//   );

//   final darkTheme = ThemeData.dark().copyWith(
//     scaffoldBackgroundColor: mygrey,
//     // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//     //     .apply(bodyColor: dark),
//     canvasColor: mygrey,
//     pageTransitionsTheme: const PageTransitionsTheme(builders: {
//       TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
//       TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
//     }),
//   );
// }
