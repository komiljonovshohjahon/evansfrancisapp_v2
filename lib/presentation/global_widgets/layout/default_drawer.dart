import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/manager/manager.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultDrawer extends StatelessWidget {
  DefaultDrawer({super.key});

  final dependencies = DependencyManager.instance;

  UserMd getUserInfo() {
    return dependencies.firestore.signedInUser!;
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = getUserInfo();
    final initial2UsernameLetters = userInfo.name.substring(0, 2).toUpperCase();
    return Drawer(
        backgroundColor: context.colorScheme.primary,
        width: context.width * .8,
        child: SafeArea(
          child: SpacedColumn(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Menus
              ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                  children: [
                    //User info
                    SpacedRow(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        horizontalSpace: 16.w,
                        children: [
                          CircleAvatar(
                            backgroundColor: context.colorScheme.onPrimary,
                            child: Text(
                              initial2UsernameLetters,
                              style: context.textTheme.headlineSmall!
                                  .copyWith(color: context.colorScheme.primary),
                            ),
                          ),
                          SpacedColumn(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userInfo.name,
                                  style: context.textTheme.titleLarge!.copyWith(
                                      color: context.colorScheme.onPrimary),
                                ),
                                Text(
                                  userInfo.email,
                                  style: context.textTheme.bodyMedium!.copyWith(
                                      color: context.colorScheme.onPrimary),
                                ),
                              ]),
                        ]),
                    Divider(
                        color: context.colorScheme.onPrimary, thickness: 1.w),
                    for (final basicType in basicTypes.entries.skip(1))
                      ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 0),
                          visualDensity: VisualDensity.compact,
                          isThreeLine: false,
                          minVerticalPadding: 0,
                          minLeadingWidth: 0,
                          leading: Icon(
                            basicIcons[basicType.key],
                            color: context.colorScheme.onPrimary,
                          ),
                          title: Text(
                            basicType.value,
                            softWrap: true,
                            maxLines: 2,
                          ),
                          onTap: () {
                            context.go(
                                "${MCANavigation.home}${MCANavigation.basic}",
                                extra: {"type": basicType.value});
                            //close drawer
                            Scaffold.of(context).closeDrawer();
                          },
                          titleTextStyle: context.textTheme.bodyMedium!
                              .copyWith(color: context.colorScheme.onPrimary)),
                  ]),

              //Additional info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                      color: context.colorScheme.onPrimary,
                      thickness: 1.w,
                      height: 1.h,
                      endIndent: 16.w,
                      indent: 16.w),
                  GestureDetector(
                    onTap: () {
                      launchURL(GlobalConstants.developerWebsiteUrl)
                          .then((value) {
                        if (!value) {
                          context.showError(
                              "Could not open developer's website. Please try again later.");
                        }
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/developer_logo.png',
                              width: 150.w, height: 150.h),
                          SizedBox(
                            width: context.width * .4,
                            child: Text(
                              "Affordable Christian App Developer's",
                              style: context.textTheme.titleSmall!.copyWith(
                                  color: context.colorScheme.onPrimary),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              size: 32.w, color: context.colorScheme.onPrimary)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
