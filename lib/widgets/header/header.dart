import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../responsive.dart';
import '../../services/config/themes.dart';
import '../../services/constants/constant.dart';
import '../../services/menu_controller/menu_controller.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/extension.dart';

class Header extends StatelessWidget {
  const Header({
    required this.pageName,
    this.searchBar,
    //  required this.search,
    Key? key,
  }) : super(key: key);
  final Widget? searchBar;
  final String pageName;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MyMenuController>().controlMenu,
          ),
        if (Responsive.isTablet(context) || Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: Text(
              pageName,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        if (Responsive.isDesktop(context)) Expanded(child: searchBar!),
        if (Responsive.isTablet(context)) const Spacer(),
        if (Responsive.isTablet(context))
          SizedBox(width: 300, child: Expanded(child: searchBar!)),
        if (Responsive.isMobile(context)) Expanded(child: searchBar!),
        const ProfileCard(),
    Obx(()=>    IconButton(
                onPressed: () {
                  Utils.isLightTheme.toggle();
                  Get.changeThemeMode(
                    Utils.isLightTheme.value ? ThemeMode.light : ThemeMode.dark,
                  );
                  ThemeController().saveThemeStatus();
                },
                icon: Utils.isLightTheme.value  ||  Theme.of(context).brightness == Brightness.light
                    ? const Icon(FontAwesomeIcons.solidMoon)
                    : const Icon(Icons.wb_sunny))
            .hPadding9)
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child:Utils.userNameinitials(Utils.userName).toString().toAutoLabel(color:  const Color.fromARGB(182, 75, 184, 187),bold: true)
        // InkWell(
        //   onTap: () => null,
        //   child: const CircleAvatar(child: Icon(FontAwesomeIcons.solidUser)
        ///),
        // ),
        );
  }
}
