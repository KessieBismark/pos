import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DItems {
  final IconData icon;
  final String title;
  final String? link;
  final List<String> subMenus;
  final String? route;

  DItems(
      {required this.icon,
      this.link,
      required this.title,
      required this.subMenus,
      this.route});
}

class MyDrawerItems {
  final String header;
  final List<DItems> items;

  MyDrawerItems(this.header, this.items);

  static List<MyDrawerItems> data = [
    MyDrawerItems(
      "",
      [
        DItems(
          icon: Icons.dashboard_customize,
          title: "Dashboard",
          link: "/dash",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "Items & Products",
      [
        DItems(
          icon: Icons.group_work,
          title: "Products Types",
          link: "",
          subMenus: [
            "Category-/service_category",
            "Sub Category-/service_sub_category"
          ],
        ),
        DItems(
          icon: Icons.type_specimen,
          title: "Products entry",
          link: "/entry",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "POS & Pending Sales",
      [
        DItems(
          icon: FontAwesomeIcons.bookOpenReader,
          title: "Pending Sales",
          link: "/bookings",
          subMenus: [],
        ),
        DItems(
          icon: Icons.shopping_basket,
          title: "sales",
          link: "/sales",
          subMenus: [],
        ),
        DItems(
          icon: Icons.featured_play_list,
          title: "Sales report",
          link: "/sales_report",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "Customer relation & report",
      [
        DItems(
          icon: Icons.group_add_sharp,
          title: "Customers",
          link: "/customer",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "SMS",
      [
        DItems(
          icon: Icons.message,
          title: "Sms Portal",
          link: "/sms",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "Finance & accounting",
      [
        DItems(
          icon: FontAwesomeIcons.chartBar,
          title: "income",
          link: "",
          subMenus: [
            "category-/income_category",
            "sub category-/income_sub",
            "income entry-/income"
          ],
        ),
        DItems(
          icon: FontAwesomeIcons.calculator,
          title: "expenses",
          link: "",
          subMenus: [
            "category-/expenses_category",
            "sub category-/esub",
            "expenses entry-/expenses"
          ],
        ),
      ],
    ),
    MyDrawerItems(
      "REPORT & ANALYSIS",
      [
        DItems(
          icon: FontAwesomeIcons.sellsy,
          title: "Cashflow",
          link: "/cashflow",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "Company registration & Branches",
      [
        DItems(
          icon: FontAwesomeIcons.industry,
          title: "Company info",
          link: "/cinfo",
          subMenus: [],
        ),
        DItems(
          icon: FontAwesomeIcons.codeBranch,
          title: "branches",
          link: "/branches",
          subMenus: [],
        ),
      ],
    ),
    MyDrawerItems(
      "User Account",
      [
        DItems(
          icon: Icons.verified_user,
          title: "Accounts",
          link: "/accounts",
          subMenus: [],
        ),
      ],
    ),
  ];
}
