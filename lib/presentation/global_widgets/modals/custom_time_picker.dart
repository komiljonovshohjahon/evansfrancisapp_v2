import 'package:flutter/material.dart';

Future<TimeOfDay?> showCustomTimePicker(
  BuildContext context, {
  TimeOfDay? initialTime,
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime ?? const TimeOfDay(hour: 0, minute: 0),
    cancelText: "Close".toUpperCase(),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light(useMaterial3: true)
            .copyWith(colorScheme: const ColorScheme.light()),
        child: child!,
      );
    },
  );
}
