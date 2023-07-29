import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';

///////////

extension DateTimeHelpers on DateTime {
  //2023-01-01
  String get toDateWithDash => DateFormat("yyyy-MM-dd").format(this);

  //01/01/2023
  String get toDateWithSlash => DateFormat("dd/MM/yyyy").format(this);

  //11:00
  String get toTime => DateFormat("HH:mm").format(this);

  //2023-01-01 11:00
  String get toDateTimeWithDash => DateFormat("yyyy-MM-dd HH:mm").format(this);

  //2023/01/01 11:00
  String get toDateTimeWithSlash => DateFormat("yyyy/MM/dd HH:mm").format(this);
}

///////////

extension TimeOfDayExtensions on TimeOfDay {
  String get toTime {
    return "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
  }
}

///////////

//////////

mixin FormsMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get isFormValid => formKey.currentState?.validate() ?? false;

  void validateForm() {
    formKey.currentState?.validate();
  }

  void resetForm() {
    formKey.currentState?.reset();
  }

  final controller1 = TextEditingController();

  Widget textField1(
      {required String label, String? Function(String?)? validator}) {
    return DefaultTextField(
      label: label,
      controller: controller1,
      validator: validator,
    );
  }

  final controller2 = TextEditingController();

  Widget textField2(
      {required String label,
      String? Function(String?)? validator,
      int? maxLines}) {
    return DefaultTextField(
      label: label,
      controller: controller2,
      validator: validator,
      maxLines: maxLines,
    );
  }

  final controller3 = TextEditingController();

  Widget textField3(
      {required String label, String? Function(String?)? validator}) {
    return DefaultTextField(
      label: label,
      controller: controller3,
      validator: validator,
    );
  }

  final controller4 = TextEditingController();

  Widget textField4(
      {required String label, String? Function(String?)? validator}) {
    return DefaultTextField(
      label: label,
      controller: controller4,
      validator: validator,
    );
  }

  final controller5 = TextEditingController();

  Widget textField5(
      {required String label, String? Function(String?)? validator}) {
    return DefaultTextField(
      label: label,
      controller: controller5,
      validator: validator,
    );
  }

  DefaultMenuItem? selected1;

  Widget dropdown1(
      {required String label,
      required List<DefaultMenuItem> list,
      double? width}) {
    return DefaultDropdown(
        label: label,
        width: width,
        onChanged: (value) {
          setState(() {
            selected1 = value;
          });
        },
        valueId: selected1?.id,
        items: list);
  }

  DefaultMenuItem? selected2;

  Widget dropdown2(String label, List<DefaultMenuItem> list, {double? width}) {
    return DefaultDropdownMenu(
        label: label,
        width: width,
        onSelected: (value) {
          setState(() {
            selected2 = value;
          });
        },
        initialValue: selected2,
        items: list);
  }

  DefaultMenuItem? selected3;

  Widget dropdown3(String label, List<DefaultMenuItem> list, {double? width}) {
    return DefaultDropdownMenu(
        label: label,
        width: width,
        onSelected: (value) {
          setState(() {
            selected3 = value;
          });
        },
        initialValue: selected3,
        items: list);
  }

  DefaultMenuItem? selected4;

  Widget dropdown4(String label, List<DefaultMenuItem> list, {double? width}) {
    return DefaultDropdownMenu(
        label: label,
        width: width,
        onSelected: (value) {
          setState(() {
            selected4 = value;
          });
        },
        initialValue: selected4,
        items: list);
  }

  DefaultMenuItem? selected5;

  Widget dropdown5(String label, List<DefaultMenuItem> list, {double? width}) {
    return DefaultDropdownMenu(
        label: label,
        width: width,
        onSelected: (value) {
          setState(() {
            selected5 = value;
          });
        },
        initialValue: selected5,
        items: list);
  }

  DateTime? selectedDate1;

  Widget datePicker1(
    String label, {
    String? Function(String?)? validator,
    double? width,
  }) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text: selectedDate1 == null ? "" : selectedDate1!.toDateWithDash,
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate1);
        if (date != null) {
          setState(() {
            selectedDate1 = date;
          });
        }
      },
    );
  }

  DateTime? selectedDate2;

  Widget datePicker2(String label,
      {String? Function(String?)? validator, double? width}) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text: selectedDate2 == null ? "" : selectedDate2!.toDateWithDash,
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate1);
        if (date != null) {
          setState(() {
            selectedDate2 = date;
          });
        }
      },
    );
  }

  DateTime? selectedDate3;

  Widget datePicker3(String label,
      {String? Function(String?)? validator, double? width}) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text: selectedDate3 == null ? "" : selectedDate3!.toDateWithDash,
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate3);
        if (date != null) {
          setState(() {
            selectedDate3 = date;
          });
        }
      },
    );
  }

  DateTime? selectedDate4;

  Widget datePicker4(String label,
      {String? Function(String?)? validator, double? width}) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text: selectedDate4 == null ? "" : selectedDate4!.toDateWithDash,
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate4);
        if (date != null) {
          setState(() {
            selectedDate4 = date;
          });
        }
      },
    );
  }

  DateTime? selectedDate5;

  Widget datePicker5(String label,
      {String? Function(String?)? validator, double? width}) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text: selectedDate5 == null ? "" : selectedDate5!.toDateWithDash,
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate5);
        if (date != null) {
          setState(() {
            selectedDate5 = date;
          });
        }
      },
    );
  }

  bool checked1 = false;
  bool checked2 = false;
  bool checked3 = false;
  bool checked4 = false;
  bool checked5 = false;

  TimeOfDay? selectedTime1;
  TimeOfDay? selectedTime2;
  TimeOfDay? selectedTime3;
  TimeOfDay? selectedTime4;
  TimeOfDay? selectedTime5;

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    super.dispose();
  }
}

//////////

final _deps = DependencyManager.instance;

/////////

extension ContextHelper on BuildContext {
  void showError(String message) {
    _deps.navigation.showFail(message);
  }

  Future<T> futureLoading<T>(Future<T> Function() callback) async {
    return await _deps.navigation.futureLoading<T>(() async {
      return await callback();
    });
  }

  void showSuccess(String message) {
    _deps.navigation.showSuccess(message);
  }

  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;

  double get height => size.height;

  void showBanner(String message) {
    ScaffoldMessenger.of(this).showMaterialBanner(MaterialBanner(
      leading: Icon(
        Icons.notification_add_rounded,
        color: theme.primaryColor,
      ),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              ScaffoldMessenger.of(this).clearMaterialBanners();
            },
            child: const Text("Dismiss"))
      ],
    ));
    Future.delayed(const Duration(seconds: 5), () {
      if (ScaffoldMessenger.of(this).mounted) {
        ScaffoldMessenger.of(this).clearMaterialBanners();
      }
    });
  }
}

/////////////

//Create a mixin which is extended by Equatable and has above functions to must override
//copyWith

mixin DataSourceMixin<T> implements Equatable {
  T copyWith();

  @override
  bool? get stringify => true;

  void dispose();
}

///////////////

extension StringHelpers on String {
  String get youtubeLinkToId {
    if (isYouTubeLink(this)) {
      return split("watch?v=")[1];
    }
    return "";
  }
}

///////////////
