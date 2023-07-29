import 'package:admin_panel_web/presentation/global_widgets/default_card.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView>
    with FormsMixin<ScheduleView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultCard(title: "Schedule", items: [
        DefaultCardItem(
          title: "Date",
          simpleText: selectedDate1?.toDateWithDash ?? "Select Date",
          onSimpleTextTapped: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            ).then((value) {
              if (value != null) {
                selectedDate1 = value;
                setState(() {});
              }
            });
          },
        ),
        DefaultCardItem(
          title: "Time",
          simpleText: selectedTime1?.format(context) ?? "Select Time",
          onSimpleTextTapped: () {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).then((value) {
              if (value != null) {
                selectedTime1 = value;
                setState(() {});
              }
            });
          },
        ),
        DefaultCardItem(
            customWidget: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Add Schedule"),
          ),
        ))
      ]),
    );
  }
}
