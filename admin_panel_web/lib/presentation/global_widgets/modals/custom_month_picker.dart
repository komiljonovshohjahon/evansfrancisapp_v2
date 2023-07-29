// import 'package:month_year_picker/month_year_picker.dart';
// import '../../theme/theme.dart';
//
// Future<DateTime?> showCustomMonthPicker(
//   BuildContext context, {
//   DateTime? initialTime,
// }) {
//   return showMonthYearPicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(2000),
//     lastDate: DateTime(2030),
//     locale: const Locale("en", "US"),
//     initialMonthYearPickerMode: MonthYearPickerMode.month,
//     builder: (context, child) {
//       return Theme(
//         data: ThemeData.light(useMaterial3: true).copyWith(
//             colorScheme: ColorScheme.light(primary: ThemeColors.MAIN_COLOR)),
//         child: child!,
//       );
//     },
//   );
//   // final res = showModalBottomSheet<DateTime>(
//   //   context: context,
//   //   builder: (ctx) {
//   //     return YearPicker(
//   //       selectedDate: DateTime(1997),
//   //       firstDate: DateTime(1995),
//   //       lastDate: DateTime.now(),
//   //       currentDate: DateTime.now(),
//   //       initialDate: initialTime,
//   //       onChanged: (val) {
//   //         Navigator.pop<DateTime>(context, val);
//   //       },
//   //     );
//   //   },
//   // );
//   // return res;
// }
