import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/global_extensions.dart';
import 'package:evansfrancisapp/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialMediaView extends StatelessWidget {
  const SocialMediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DependencyManager.instance.firestore
            .getCollectionBasedListStream<BasicMd>(
            collection: FirestoreDep.socialMediaCn,
            fromJson: (p0) => BasicMd.fromJson(p0),
            toJson: (p0) => p0.toJson()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = (snapshot.data ?? []).toList();

          if (list.isEmpty) return const Center(child: Text("No data found"));

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Wrap(
              spacing: 40.w,
              runSpacing: 40.h,
              alignment: WrapAlignment.center,
              children: [for (final item in list) _SocialMediaItem(item: item)],
            ),
          );
        });
  }
}

class _SocialMediaItem extends StatelessWidget {
  final BasicMd item;

  const _SocialMediaItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.message.isEmpty) return;
        launchURL(item.message);
      },
      child: Container(
        width: context.width * 0.4,
        height: 200.h,
        decoration: BoxDecoration(
          // color: context.theme.primaryColor,
          borderRadius: BorderRadius.circular(10.r),
          gradient: LinearGradient(
            colors: [
              context.colorScheme.secondary.withOpacity(.5),
              context.colorScheme.primary,
              context.colorScheme.secondary.withOpacity(.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SpacedColumn(
          verticalSpace: 10.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (socialMedia[item.type]?['icon'] != null)
              Icon(socialMedia[item.type]!['icon'],
                  size: 64.w, color: context.colorScheme.onPrimary),
            Text(item.type,
                style: context.textTheme.titleLarge
                    ?.copyWith(color: context.colorScheme.onPrimary)),
          ],
        ),
      ),
    );
  }
}
