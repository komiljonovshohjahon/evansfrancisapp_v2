// ignore_for_file: use_build_context_synchronously

import 'package:country_picker/country_picker.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerRequestView extends StatefulWidget {
  const PrayerRequestView({super.key});

  @override
  State<PrayerRequestView> createState() => _PrayerRequestViewState();
}

class _PrayerRequestViewState extends State<PrayerRequestView>
    with FormsMixin<PrayerRequestView> {
  final deps = DependencyManager.instance;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: formKey,
        child: SpacedColumn(
          verticalSpace: 16.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 1.h),
            DefaultTextField(
              label: "Name",
              disabled: true,
              initialValue: deps.firestore.signedInUser!.name,
            ),
            DefaultTextField(
              label: "Contact Number",
              disabled: true,
              initialValue: deps.firestore.signedInUser!.phone,
            ),
            DefaultTextField(
              label: "Email",
              disabled: true,
              initialValue: deps.firestore.signedInUser!.email,
            ),
            // textField1(
            //   label: "Full Name",
            //   validator: (p0) {
            //     if (p0!.isEmpty) return "Please enter your full name";
            //     return null;
            //   },
            // ),
            // textField2(
            //   label: "Contact No",
            //   validator: (p0) {
            //     if (p0!.isEmpty) return "Please enter your contact number";
            //     return null;
            //   },
            // ),
            // textField3(
            //   label: "Email",
            //   validator: (p0) {
            //     if (p0!.isEmpty) return "Please enter your email";
            //     return null;
            //   },
            // ),
            textField4(
                label: "Country",
                validator: (p0) {
                  if (p0!.isEmpty) return "Please enter your country";
                  return null;
                },
                onTap: () {
                  showCountryPicker(
                      context: context,
                      onSelect: (value) {
                        controller4.text = value.name;
                        selected4 = DefaultMenuItem(
                            id: 0,
                            title: value.name,
                            additionalId: value.countryCode);
                      });
                }),
            textField5(
                label: "State",
                validator: (p0) {
                  if (p0!.isEmpty) return "Please enter your state";
                  return null;
                }),
            textField6(
                label: "City",
                validator: (p0) {
                  if (p0!.isEmpty) return "Please enter your city";
                  return null;
                }),
            dropdown1(label: "Prayer For", width: context.width * .9, list: [
              for (final item in prayerRequestTypes.entries)
                DefaultMenuItem(id: item.key, title: item.value)
            ]),
            textField8(
                label: "Message",
                validator: (p0) {
                  if (p0!.isEmpty) return "Please enter your message";
                  return null;
                }),
            const SizedBox(height: 0),
            SizedBox(
              width: context.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.secondary,
                  foregroundColor: context.colorScheme.onSecondary,
                ),
                onPressed: submit,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    context.futureLoading(() async {
      final success = await deps.firestore.createOrUpdatePrayerRequest(
          model: PrayerRequestMd.init().copyWith(
        message: controller8.text,
        city: controller6.text,
        // fullname: controller1.text,
        // email: controller3.text,
        // contactNo: controller2.text,
        countryCode: selected4!.additionalId!,
        prayerFor: selected1!.id,
        state: controller5.text,
      ));
      if (success.isRight) {
        context.pop();
        context.showSuccess("Prayer request submitted successfully");
      } else if (success.isLeft) {
        context.showError(success.left);
      } else {
        context.showError("Failed to submit prayer request");
      }
    });
  }
}
