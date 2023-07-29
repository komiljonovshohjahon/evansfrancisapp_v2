// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactChurchOfficeView extends StatefulWidget {
  const ContactChurchOfficeView({super.key});

  @override
  State<ContactChurchOfficeView> createState() =>
      _ContactChurchOfficeViewState();
}

class _ContactChurchOfficeViewState extends State<ContactChurchOfficeView>
    with FormsMixin<ContactChurchOfficeView> {
  final deps = DependencyManager.instance;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: formKey,
        child: SpacedColumn(
          verticalSpace: 24.h,
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
            textField2(
                label: "Message",
                maxLines: 5,
                validator: (p0) {
                  if (p0!.isEmpty) return "Message is required";
                  return null;
                }),
            const SizedBox(height: 1),
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
      final success = await deps.firestore.createOrUpdateContactChurch(
          model: ChurchContactMd.init().copyWith(message: controller2.text));
      if (success.isRight) {
        context.pop();
        context.showSuccess("Request submitted successfully");
      } else if (success.isLeft) {
        context.showError(success.left);
      } else {
        context.showError("Failed to submit!");
      }
    });
  }
}
