import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_web/presentation/global_widgets/layout/default_navigation_rail.dart';
import 'package:admin_panel_web/presentation/global_widgets/layout/page_wrapper.dart';

class DefaultLayout extends StatefulWidget {
  final Widget child;
  const DefaultLayout({super.key, required this.child});

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  bool showNavigationBar = true;

  void switchExtended() {
    setState(() {
      showNavigationBar = !showNavigationBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(onMenuPressed: switchExtended),
      body: Row(
        children: [
          // if (showNavigationBar)
          MouseRegion(
              onEnter: (event) {
                if (kDebugMode) return;
                setState(() {
                  showNavigationBar = true;
                });
              },
              onExit: (event) {
                setState(() {
                  showNavigationBar = false;
                });
              },
              child: DefaultNavigationRail(isExtended: showNavigationBar)),
          Expanded(
              child: Column(
            children: [
              Expanded(child: PageWrapper(child: widget.child)),
            ],
          )),
        ],
      ),
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: MenuButton(onMenuPressed: onMenuPressed),
      title: const Text("KRCI Admin test"),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onMenuPressed,
      icon: const Icon(Icons.menu),
    );
  }
}
