import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/constants/color.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/drawer_list.dart';
import '../../services/widgets/expanded_list.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/richtext.dart';
import 'model.dart';

class MyDrawer extends StatelessWidget {
  final String? selectedItem;
  final String? name;
  const MyDrawer({Key? key, this.selectedItem, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: Column(
        children: [
          DrawerHeader(
              curve: Curves.easeIn,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/icons/logo.png",
                        height: 40,
                      ).padding3,
                      "e3".toLabel(
                          bold: true,
                          fontsize: 25,
                          color: const Color.fromARGB(182, 75, 184, 187))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  "Welcome ${Utils.userName}".toLabel(fontsize: 15),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: "Logout".toAutoLabel(
                        color: const Color.fromARGB(182, 75, 184, 187)),
                    onTap: () => Utils.logOut(),
                  )
                ],
              )),
          Expanded(
            child: ListView.builder(
              itemCount: MyDrawerItems.data.length,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: MyDrawerItems.data[index].header
                          .toUpperCase()
                          .toLabel(bold: true, color: lightGrey, fontsize: 15),
                    ).vPadding9.hPadding9.hMargin9,
                    for (int i = 0;
                        i < MyDrawerItems.data[index].items.length;
                        i++)
                      MyDrawerItems.data[index].items[i].subMenus.isEmpty
                          ? DrawerItem(
                              leading: Get.isDarkMode
                                  ? MyDrawerItems.data[index].items[i].link ==
                                          selectedItem
                                      ? Icon(
                                          MyDrawerItems
                                              .data[index].items[i].icon,
                                        )
                                      : Icon(
                                          MyDrawerItems
                                              .data[index].items[i].icon,
                                          color: Colors.grey.shade400,
                                        )
                                  : MyDrawerItems.data[index].items[i].link ==
                                          selectedItem
                                      ? Icon(
                                          MyDrawerItems
                                              .data[index].items[i].icon,
                                          //color: grey,
                                        )
                                      : Icon(
                                          MyDrawerItems
                                              .data[index].items[i].icon,
                                          color: grey,
                                        ),
                              // selected:
                              //     MyDrawerItems.data[index].items[i].link ==
                              //             selectedItem
                              //         ? true
                              //         : false,
                              onTap: () => Get.offNamed(
                                  MyDrawerItems.data[index].items[i].link!),
                              title: MyDrawerItems
                                  .data[index].items[i].title.capitalize!
                                  .toLabel(fontsize: 16),
                            )
                          : ExpandItems(
                              selectedItem: selectedItem,
                              name: name,
                              leading: MyDrawerItems.data[index].items[i].icon,
                              title: MyDrawerItems.data[index].items[i].title
                                  .toUpperCase(),
                              subMenus:
                                  MyDrawerItems.data[index].items[i].subMenus,
                            ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: _launchURL,
            child: MyRichText(
              mainText: "Developed by ",
              subText: "BISTECH GHANA",
              mainStyle: TextStyle(color: lightGrey, fontSize: 14),
              subStyle: const TextStyle(
                  color: Color.fromARGB(182, 75, 184, 187), fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'https://bistechgh.com/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
