import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DefaultNavigationRail extends StatelessWidget {
  final bool isExtended;

  DefaultNavigationRail({super.key, required this.isExtended});

  final dependencies = DependencyManager.instance;

  int get selectedIndex {
    final route = dependencies.navigation.router.location;
    final int index = adminDestinations.keys
        .toList()
        .indexWhere((element) => "/$element" == route);
    if (index.isNegative) return 0;
    return index;
  }

  void onDestinationSelected(int index, BuildContext context) {
    if (index == selectedIndex) return;
    final route = "/${adminDestinations.keys.toList()[index]}";
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   width: 200,
    //   child: NavigationDrawer(
    //       selectedIndex: selectedIndex,
    //       onDestinationSelected: (index) =>
    //           onDestinationSelected(index, context),
    //       children: [
    //         for (final destination in destinations)
    //           NavigationDrawerDestination(
    //             icon: Badge(label: Text("2"), child: Icon(destination['icon'])),
    //             label: label(destination['title']),
    //           ),
    //       ]),
    // );
    return NavigationRail(
      selectedIndex: selectedIndex,
      extended: kDebugMode ? true : isExtended,
      elevation: 10,
      minExtendedWidth: 200,
      onDestinationSelected: (index) => onDestinationSelected(index, context),
      destinations: [
        for (final destination in adminDestinations.entries)
          NavigationRailDestination(
            icon: Badge(
                isLabelVisible: destination.value['badgeCount'] != null &&
                    destination.value['badgeCount'] > 0,
                label: Text(destination.value['badgeCount'].toString()),
                child: Icon(destination.value['icon'])),
            label: label(destination.value['title']),
          ),
      ],
    );
  }

  Widget label(String label) {
    return SizedBox(
      width: 100,
      child: Text(
        label,
        maxLines: 2,
        softWrap: true,
      ),
    );
  }
}
