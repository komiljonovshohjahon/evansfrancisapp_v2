// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitSpecialRequestView extends StatefulWidget {
  const SubmitSpecialRequestView({super.key});

  @override
  State<SubmitSpecialRequestView> createState() =>
      _SubmitSpecialRequestViewState();
}

class _SubmitSpecialRequestViewState extends State<SubmitSpecialRequestView>
    with FormsMixin<SubmitSpecialRequestView> {
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
            dropdown1(label: "Subject for", width: context.width * .9, list: [
              for (final item in specialRequestTypes.entries)
                DefaultMenuItem(id: item.key, title: item.value)
            ]),
            textField2(
                maxLines: 5,
                label: "Description",
                validator: (p0) {
                  if (p0!.isEmpty) return "Please enter description";
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
      final success = await deps.firestore.createOrUpdateSpecialRequest(
          model: SpecialRequestMd.init().copyWith(
              requestType: selected1?.id, description: controller2.text));
      if (success.isRight) {
        context.pop();
        context.showSuccess("Prayer request submitted successfully");
      } else if (success.isLeft) {
        context.showError(success.left);
      } else {
        context.showError("Failed to submit");
      }
    });
  }
}
