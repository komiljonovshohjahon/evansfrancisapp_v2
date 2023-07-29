import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with FormsMixin<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return const Text("Dashboard");
  }
}
