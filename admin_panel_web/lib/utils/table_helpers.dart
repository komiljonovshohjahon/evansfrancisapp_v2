// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';

/////////

extension WidgetHelper on PlutoColumnRendererContext {
  Widget defaultText(
      {bool isSelectable = false, String? title, bool isActive = true}) {
    final text = Text(
        (title ?? (cell.value?.toString() ?? "-")).isEmpty
            ? "-"
            : title ?? (cell.value?.toString() ?? "-"),
        maxLines: 2,
        softWrap: true,
        textAlign: isSelectable ? TextAlign.center : TextAlign.start,
        style: stateManager.style.cellTextStyle.copyWith(
          color: isSelectable ? Colors.redAccent : Colors.black,
          fontWeight: isSelectable ? FontWeight.bold : FontWeight.normal,
          decoration:
              !isActive ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: Colors.black,
          decorationThickness: 1,
        ));
    return text;
  }

  Widget defaultTooltipWidget({String? title, required BuildContext context}) {
    return TextButton(
        onPressed: () {
          //show simple dialog
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                      width: 300,
                      height: 300,
                      child: SingleChildScrollView(
                          child: Text(cell.value.toString()))),
                  actions: [
                    TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text("Close"))
                  ],
                );
              });
        },
        child: Text(title ?? "Read Only"));
    return Tooltip(
      message: cell.value.toString().isEmpty ? "---" : cell.value.toString(),
      child: defaultText(
        title: title ?? "Read Only",
        isSelectable: true,
      ),
    );
  }

  Widget actionMenuWidget({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onView,
  }) {
    return PopupMenuButton(
      offset: const Offset(0, 40),
      padding: const EdgeInsets.all(0),
      itemBuilder: (context) => [
        if (onView != null)
          const PopupMenuItem(
            value: 0,
            child: Text("View"),
          ),
        if (onEdit != null)
          const PopupMenuItem(
            value: 1,
            child: Text("Edit"),
          ),
        if (onDelete != null)
          const PopupMenuItem(
            value: 2,
            child: Text("Delete"),
          ),
      ],
      onSelected: (value) {
        switch (value) {
          case 0:
            onView?.call();
            break;
          case 1:
            onEdit?.call();
            break;
          case 2:
            onDelete?.call();
            break;
        }
      },
    );
  }
}

/////////

////////

mixin TableFocusNodeMixin<T extends StatefulWidget, MD> on State<T> {
  final DependencyManager dependencyManager = DependencyManager.instance;

  bool enableLoading = true;

  late final FocusNode focusNode;

  PlutoGridStateManager? stateManager;

  List<PlutoColumn> columns = [];

  List<PlutoRow> get rows => stateManager == null ? [] : stateManager!.rows;

  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    focusNode = FocusNode(onKey: (node, event) {
      if (event is RawKeyUpEvent) {
        return KeyEventResult.handled;
      }

      return stateManager!.keyManager!.eventResult.skip(KeyEventResult.ignored);
    });
    super.initState();
  }

  @override
  void dispose() {
    stateManager?.gridFocusNode.removeListener(handleFocus);
    super.dispose();
  }

  PlutoGridStateManager setRows(PlutoGridStateManager sm, List<PlutoRow> rs) {
    sm.removeAllRows();
    sm.appendRows(rs);
    final sortedColumn = sm.getSortedColumn;
    if (sortedColumn != null) {
      if (sortedColumn.sort.isAscending) {
        sm.sortAscending(sortedColumn);
      } else if (sortedColumn.sort.isDescending) {
        sm.sortDescending(sortedColumn);
      }
    }
    return sm;
  }

  void onDidChange(List<MD> newItems) {
    setRows(stateManager!, newItems.map((e) => buildRow(e)).toList());
  }

  void handleFocus() {
    stateManager?.setKeepFocus(!focusNode.hasFocus);
  }

  Future<A> loading<A>(Future<A> Function() callback) async {
    if (GlobalConstants.enableLoadingIndicator && enableLoading) {
      stateManager!.setShowLoading(true, level: PlutoGridLoadingLevel.rows);
    }
    final res = await callback();

    if (GlobalConstants.enableLoadingIndicator && enableLoading) {
      stateManager!.setShowLoading(false);
    }
    return res;
  }

  PlutoRow buildRow(MD model) {
    return PlutoRow(cells: {});
  }

  void onLoaded(PlutoGridOnLoadedEvent event) async {
    stateManager = event.stateManager;
    stateManager!.keyManager!.eventResult.skip(KeyEventResult.ignored);
    final list = await loading<List<MD>?>(() async => await fetch());
    stateManager!.gridFocusNode.addListener(handleFocus);
    if (list != null) {
      setRows(stateManager!, list.map((e) => buildRow(e)).toList());
    }
  }

  Future<List<MD>?> fetch() {
    return Future.value(null);
  }

  Future<void> onDelete(Future<bool> Function() callback,
      {bool showError = true}) async {
    final agreeToDelete = await dependencyManager.navigation.showAlert(context);
    if (agreeToDelete != true) return;
    try {
      context.futureLoading(() async {
        final success = await callback();
        if (success) {
          final l = await fetch();
          setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
          context.showSuccess("Deleted successfully!");
        } else {
          if (showError) context.showError("Cannot delete!");
        }
      });
    } catch (e) {
      if (showError) context.showError(e.toString());
    }
  }

  Future<void> onEdit(Widget Function(MD?) child, MD? model,
      {bool showSuccess = true}) async {
    if (stateManager!.hasFocus) {
      stateManager?.gridFocusNode.removeListener(handleFocus);
    }
    final res =
        await DependencyManager.instance.navigation.showCustomDialog<bool>(
            context: context,
            builder: (context) {
              return child(model);
            });

    if (res != null && res) {
      final l = await loading<List<MD>?>(() async => await fetch());
      setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
      if (showSuccess) {
        context.showSuccess("");
      }
    }
  }
}

/////////
