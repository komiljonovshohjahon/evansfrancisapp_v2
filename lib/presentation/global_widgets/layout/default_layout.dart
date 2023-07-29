import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/layout/default_drawer.dart';
import 'package:evansfrancisapp/presentation/pages/home/home_view.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:evansfrancisapp/presentation/global_widgets/layout/page_wrapper.dart';

class DefaultLayout extends StatefulWidget {
  final Widget child;
  const DefaultLayout({super.key, required this.child});

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      resizeToAvoidBottomInset: true,
      body: PageWrapper(child: widget.child),
      drawer: DefaultDrawer(),
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final route = context.routeName.split("/").last;
    String? title;
    try {
      title = homeMenus.firstWhere((element) {
        return element["route"].toString().substring(1) == route;
      })["title"] as String?;
      // ignore: empty_catches
    } catch (e) {}
    return AppBar(
      leading: route == "home"
          ? const DrawerButton()
          : context.canPop()
              ? IconButton(
                  onPressed: context.pop,
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
      centerTitle: true,
      title: context.canPop() && title != null
          ? Text(title)
          : Image.asset(
              "assets/images/dilkumar_logo.png",
              fit: BoxFit.cover,
            ),
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
