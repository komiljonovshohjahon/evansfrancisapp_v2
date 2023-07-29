import 'package:evansfrancisapp/utils/global_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultListTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final ImageProvider? image;
  final VoidCallback? onTap;
  final String? heroTag;
  const DefaultListTile(
      {super.key,
      this.title,
      this.subtitle,
      this.image,
      this.onTap,
      this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: context.colorScheme.secondary.withOpacity(0.2),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shadowColor: context.colorScheme.secondary.withOpacity(0.6),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        title: title == null
            ? null
            : Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        titleTextStyle:
            context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        subtitleTextStyle: context.textTheme.bodySmall!,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
        trailing: image == null
            ? null
            : Hero(
                tag: heroTag ?? image!.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image(
                    image: image!,
                    width: 150.w,
                    height: 150.h,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                    fit: BoxFit.fill,
                  ),
                ),
              ),
      ),
    );
  }
}
