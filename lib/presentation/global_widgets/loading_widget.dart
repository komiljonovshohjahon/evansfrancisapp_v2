import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets.dart';

class AppLoadingWidget extends StatelessWidget {
  final VoidCallback? onClose;
  const AppLoadingWidget({Key? key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.all(Radius.circular(8.r))),
      child: SpacedColumn(
        mainAxisSize: MainAxisSize.min,
        verticalSpace: 16.h,
        children: [
          const CircularProgressIndicator(),
          if (onClose != null)
            ElevatedButton(onPressed: onClose, child: const Text("Cancel"))
        ],
      ),
    );
  }
}
