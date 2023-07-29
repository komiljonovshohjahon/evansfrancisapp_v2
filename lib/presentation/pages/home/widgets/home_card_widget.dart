import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/manager/manager.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCardWidget extends StatelessWidget {
  final String route;
  final String title;
  final IconData? icon;
  final String? image;
  final double? headerFontSize;

  const HomeCardWidget(
      {super.key,
      required this.route,
      this.icon,
      required this.title,
      this.image,
      this.headerFontSize});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: context.colorScheme.primary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          context.go("${MCANavigation.home}$route");
        },
        child: Container(
            height: 160.h,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(
                        icon,
                        size: 48.w,
                        color: context.colorScheme.onSecondary,
                      ),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontSize: (headerFontSize ?? 32).sp,
                          color: context.colorScheme.onSecondary,
                        )),
                  ],
                )),
                if (image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.asset(
                      image!,
                      width: 300.w,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}
