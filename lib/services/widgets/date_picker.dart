import 'package:flutter/material.dart';

import '../constants/color.dart';
import 'extension.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime firstDate;
  final Function(DateTimeRange?)? dateRange;
  final String? selectedDate;
  const DateRangePicker(
      {Key? key, required this.firstDate, this.dateRange, this.selectedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showDateRangePicker(
                context: context,
                firstDate: firstDate,
                lastDate: DateTime(9999))
            .then((value) => dateRange

                //    {
                // if (value != null) {
                //   controller.setDate.value = false;

                //   DateTimeRange fromRange =
                //       DateTimeRange(start: DateTime.now(), end: DateTime.now());
                //   fromRange = value;

                //   controller.selectedDate =
                //       "${DateFormat.yMMMd().format(fromRange.start)} - ${DateFormat.yMMMd().format(fromRange.end)}";
                //   controller.sdate.text = DateFormat.yMMMd().format(fromRange.start);
                //   controller.edate.text = DateFormat.yMMMd().format(fromRange.end);
                //   controller.fromDate = fromRange.start;
                //   controller.toDate = fromRange.end;
                // }

                // if (controller.selectedDate.isEmpty) {
                //   controller.setDate.value = false;
                // } else {
                //   controller.setDate.value = true;
                // }
                // });
                );
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: const Icon(Icons.calendar_today, color: secondaryColor),
        title: selectedDate!.isEmpty
            ? "Click here to select date range".toAutoLabel()
            : selectedDate!.toLabel(),
      ).vPadding3,
    );
  }
}

class DateTimePicker extends StatelessWidget {
  final String date;
  final VoidCallback ontap;
  const DateTimePicker(
      {Key? key, required this.date, required this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: const Icon(Icons.calendar_today, color: secondaryColor),
        title: date.toLabel(),
      ).vPadding3,
    );
  }
}
