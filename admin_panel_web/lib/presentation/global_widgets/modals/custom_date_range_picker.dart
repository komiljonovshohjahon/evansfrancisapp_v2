import 'package:flutter/material.dart';

Future<DateTimeRange?> showCustomDateRangePicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTimeRange? initialDateRange,
}) {
  return showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    currentDate: initialDate,
    anchorPoint: const Offset(0.5, 0.5),
    initialDateRange: initialDateRange,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light(useMaterial3: true)
            .copyWith(colorScheme: const ColorScheme.dark()),
        child: child!,
      );
    },
  );
}
