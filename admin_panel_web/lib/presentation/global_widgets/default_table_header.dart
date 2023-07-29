import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DefaultTableHeader extends StatefulWidget {
  final PlutoGridStateManager stateManager;
  final FocusNode? focusNode;
  final Widget? headerEnd;

  /// Pass focusNode in order to make the search field functional
  const DefaultTableHeader(
      {super.key, required this.stateManager, this.focusNode, this.headerEnd});

  @override
  State<DefaultTableHeader> createState() => _DefaultTableHeaderState();
}

class _DefaultTableHeaderState extends State<DefaultTableHeader> {
  PlutoGridStateManager get stateManager => widget.stateManager;
  FocusNode? get focusNode => widget.focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: focusNode != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            // search field
            if (focusNode != null)
              DefaultTextField(
                width: 240,
                height: 40,
                label: "Filter",
                focusNode: focusNode,
                onChanged: (value) {
                  stateManager.setFilter((element) =>
                      element.cells.values.any((cell) => cell.value
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase())) ==
                      true);
                },
              ),

            //Menu button
            if (widget.headerEnd != null) widget.headerEnd!,
          ],
        ),
      ),
    );
  }
}
