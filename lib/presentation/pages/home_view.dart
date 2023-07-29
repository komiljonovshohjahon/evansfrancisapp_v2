import 'package:evansfrancisapp/presentation/global_widgets/default_dropdown.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text('HomeView'),
        DefaultDropdown(onChanged: (v) {}, items: [
          DefaultMenuItem(id: 1, title: "test"),
          DefaultMenuItem(id: 2, title: "test 2")
        ]),
        DefaultDropdown(
          valueId: 1,
          items: [DefaultMenuItem(id: 1, title: "test", subtitle: "test 2")],
          onChanged: (v) {},
        ),
      ],
    ));
  }
}
