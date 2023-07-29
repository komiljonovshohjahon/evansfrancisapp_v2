//create a AlertDialog widget with confirmation

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String? content;

  const ConfirmDialog({super.key, this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(32.w),
      contentTextStyle: context.textTheme.bodyMedium,
      title: title == null ? null : Text(title!),
      content: content == null ? null : Text(content!),
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            context.pop(true);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
