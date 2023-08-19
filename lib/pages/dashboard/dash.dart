import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../responsive.dart';
import '../../services/constants/constant.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/linear_graph.dart';
import '../../services/widgets/pie_chart.dart';
import '../../services/widgets/stacked_info.dart';
import '../../services/widgets/waiting.dart';
import '../../widgets/header/header.dart';
import 'component/controller/controller.dart';
import 'component/models/model.dart';

class Dash extends GetView<DashCon> {
  const Dash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Header(
              pageName: "Dashboard",
              searchBar: Container(),
            ),
            const SizedBox(
              height: 10,
            ),
            Utils.userRole == "Super Admin"
                ? Column(
                    children: [
                      if (Responsive.isDesktop(context) ||
                          Responsive.isTablet(context))
                        topSection(context),
                      if (Responsive.isMobile(context))
                        topSectionMbile(context),
                      const SizedBox(
                        height: 5,
                      ),
                      if (Responsive.isDesktop(context) ||
                          Responsive.isTablet(context))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            netProfit(
                                context,
                                myWidth(context, 2.5),
                                myHeight(context, 2.5),
                                myWidth(context, 2.5),
                                myHeight(context, 4)),
                            const SizedBox(
                              width: 5,
                            ),
                            Obx(() => controller.isFastLoad.value
                                ? const MWaiting()
                                : fastSelingWidget(
                                    context,
                                    controller.fastseling,
                                    myHeight(context, 2.5),
                                    myWidth(context, 3))).card
                          ],
                        ),
                      if (Responsive.isMobile(context))
                        Column(
                          children: [
                            netProfit(
                                context,
                                myWidth(context, 1),
                                myHeight(context, 1.5),
                                myWidth(context, 1.2),
                                myHeight(context, 2)),
                            const SizedBox(
                              width: 5,
                            ),
                            Obx(() => controller.isFastLoad.value
                                ? const MWaiting()
                                : fastSelingWidget(
                                    context,
                                    controller.fastseling,
                                    myHeight(context, 2.5),
                                    myWidth(context, 1))).card
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => controller.loadcf.value
                            ? const MWaiting()
                            : SyncCartesianChart(
                                height: 300,
                                width: 1.1,
                                title: "Cash Flow",
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <LineSeries>[
                                  LineSeries<ActModel, String>(
                                    animationDuration: 1,
                                    name: DateTime.now().year.toString(),
                                    dataSource: controller.cashflow,
                                    xValueMapper: (ActModel data, _) =>
                                        Utils.myMonth(int.parse(data.name)),
                                    yValueMapper: (ActModel data, _) =>
                                        double.parse(data.amount),
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        labelPosition:
                                            ChartDataLabelPosition.inside,
                                        overflowMode: OverflowMode.trim),
                                  ),
                                ],
                                xAxis: CategoryAxis(
                                  title: AxisTitle(
                                    text: "Month",
                                    textStyle: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                yAxis: NumericAxis(
                                  title: AxisTitle(text: "Amount"),
                                ),
                              ).padding9,
                      ).card,
                    ],
                  )
                : Center(
                    child: SizedBox(
                      width: myWidth(context, 1.2),
                      child: const Text(
                          "Only the top managers can view this section"),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Card netProfit(BuildContext context, double boxWidth, double boxHeight,
      double containerWidth, double containerHeight) {
    return Card(
      child: SizedBox(
        height: boxHeight,
        width: boxWidth,
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.pie_chart,
                  size: 30,
                  color: Color.fromARGB(255, 54, 73, 244),
                ).hPadding9.vPadding3,
                if (Responsive.isDesktop(context))
                  "Net Profit"
                      .toAutoLabel(bold: true, fontsize: 16)
                      .hPadding9
                      .vPadding3,
                const Spacer(),
                Obx(
                  () => Row(
                    children: [
                      MTextButton(
                        onTap: () {
                          controller.isMonth.value = false;
                          controller.isYear.value = false;
                          controller.isDay.value = true;
                          controller.isWeek.value = false;
                          controller.getNetProfit("day");
                        },
                        //  color: secondaryColor,
                        title: "Day",
                        active: controller.isDay.value,
                      ),
                      MTextButton(
                        onTap: () {
                          controller.isWeek.value = true;
                          controller.isMonth.value = false;
                          controller.isYear.value = false;
                          controller.isDay.value = false;
                          controller.getNetProfit("week");
                        },
                        //color: secondaryColor,
                        title: "Week",
                        active: controller.isWeek.value,
                      ),
                      MTextButton(
                        onTap: () {
                          controller.isWeek.value = false;
                          controller.isMonth.value = true;
                          controller.isYear.value = false;
                          controller.isDay.value = false;
                          controller.getNetProfit("month");
                        },
                        //   color: secondaryColor,
                        title: "Month",
                        active: controller.isMonth.value,
                      ),
                      MTextButton(
                        onTap: () {
                          controller.isWeek.value = false;
                          controller.isMonth.value = false;
                          controller.isYear.value = true;
                          controller.isDay.value = false;
                          controller.getNetProfit("year");
                        },
                        //  color: secondaryColor,
                        title: "Year",
                        active: controller.isYear.value,
                      ),
                    ],
                  ),
                ).hMargin3,
              ],
            ),
            const Divider(
              thickness: 2,
              color: Color.fromARGB(255, 54, 73, 244),
            ),
            Obx(() => controller.isNetLoad.value
                ? const Padding(
                    padding: EdgeInsets.only(top: 100), child: MWaiting())
                : SyncPieChart(
                    height: containerHeight,
                    width: containerWidth,
                    title: "Net Profit",
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <PieSeries>[
                        PieSeries<NetProfitModel, String>(
                            name: "Income / Expenses",
                            enableTooltip: true,
                            dataSource: controller.netProfit,
                            xValueMapper: (NetProfitModel data, _) =>
                                data.name.toString().toUpperCase(),
                            yValueMapper: (NetProfitModel data, _) =>
                                double.parse(data.value),
                            dataLabelMapper: (NetProfitModel data, _) =>
                                data.name.toString().toUpperCase(),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside,
                                overflowMode: OverflowMode.trim))
                      ]).padding9),
          ],
        ),
      ),
    );
  }

  Container fastSelingWidget(BuildContext context, List<FastSMondel> data,
      double height, double width) {
    return 
    Container(
      // height: myHeight(context, 2.5),
      // width: myWidth(context, 3),
      height: height,
      width: width,
     child:
      Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.star,
                size: 30,
                color: Colors.red,
              ).hPadding9.vPadding3,
              "Selling Rate"
                  .toAutoLabel(bold: true, fontsize: 16)
                  .hPadding9
                  .vPadding3
            ],
          ),
          const Divider(
            thickness: 2,
            color: Colors.red,
          ),
          FastSelling(data: data, height: height,width: width,)
        ],
      )
   );
  }

  Row topSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => StackedInfoCard(
              title: "Total Sales",
              boxWidth: myWidth(context, 4),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 4.2),
              icon: FontAwesomeIcons.handHoldingDollar,
              value: Utils().formatPrice(controller.totalSales.value),
              iconBackColor: Colors.green,
            )).animate().fade(duration: 500.ms).scale(delay: 200.ms),
        Obx(() => StackedInfoCard(
              title: "Instant Sales",
              boxWidth: myWidth(context, 4),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 4.2),
              icon: FontAwesomeIcons.userClock,
              value: controller.instant.value,
              iconBackColor: const Color.fromARGB(255, 154, 180, 4),
            )).animate().fade(duration: 500.ms).scale(delay: 300.ms),
        Obx(() => StackedInfoCard(
              title:  "Proforma / Saved",
              boxWidth: myWidth(context, 4),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 4.2),
              icon: FontAwesomeIcons.bookOpen,
              value: controller.booking.value,
              iconBackColor: const Color.fromARGB(255, 129, 11, 11),
            )).animate().fade(duration: 500.ms).scale(delay: 400.ms),
      ],
    );
  }

  Column topSectionMbile(BuildContext context) {
    return Column(
      children: [
        Obx(() => StackedInfoCard(
              title: "Total Sales",
              boxWidth: myWidth(context, 1),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 1.1),
              icon: FontAwesomeIcons.handHoldingDollar,
              value: Utils().formatPrice(controller.totalSales.value),
              iconBackColor: Colors.green,
            ).center.animate().fade(duration: 500.ms).scale(delay: 200.ms)),
        Obx(() => StackedInfoCard(
              title: "Instant Sales",
              boxWidth: myWidth(context, 1),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 1.1),
              icon: FontAwesomeIcons.userClock,
              value: controller.instant.value,
              iconBackColor: const Color.fromARGB(255, 154, 180, 4),
            ).center.animate().fade(duration: 500.ms).scale(delay: 300.ms)),
        Obx(() => StackedInfoCard(
              title: "Proformal / Saved",
              boxWidth: myWidth(context, 1),
              boxHeight: myHeight(context, 4),
              containerHeight: myHeight(context, 5),
              containerWidth: myWidth(context, 1.1),
              icon: FontAwesomeIcons.bookOpen,
              value: controller.booking.value,
              iconBackColor: const Color.fromARGB(255, 129, 11, 11),
            ).center.animate().fade(duration: 500.ms).scale(delay: 300.ms)),
      ],
    );
  }
}

class FastSelling extends StatelessWidget {
  final List<FastSMondel> data;
  final double height;
  final double width;
  const FastSelling({super.key, required this.data, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Expanded(
 flex: 4,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, index) {
          return ListTile(
            leading: (index + 1).toString().toLabel(bold: true),
            title: data[index].name.toAutoLabel(),
            trailing: data[index].count.toLabel(),
          );
        },
      ),
    );
  }
}
