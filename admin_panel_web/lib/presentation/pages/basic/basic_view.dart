// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:pluto_grid/pluto_grid.dart';

import 'create_new.dart';

class BasicView extends StatefulWidget {
  const BasicView({super.key});

  @override
  State<BasicView> createState() => _BasicViewState();
}

class _BasicViewState extends State<BasicView>
    with TableFocusNodeMixin<BasicView, BasicMd> {
  ValueNotifier<DefaultMenuItem> selectedMenuItem =
      ValueNotifier<DefaultMenuItem>(
          DefaultMenuItem(id: 0, title: basicTypes['all']!));

  @override
  void initState() {
    super.initState();
    selectedMenuItem.addListener(() {
      loading<void>(() async {
        final l = await fetch();
        setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
        headerEnd: SpacedRow(
          horizontalSpace: 10,
          children: [
            ValueListenableBuilder(
              valueListenable: selectedMenuItem,
              builder: (context, menuItem, child) => DefaultDropdown(
                label: "Select Category",
                valueId: menuItem.id,
                width: 300,
                items: [
                  for (int i = 0; i < basicTypes.length; i++)
                    DefaultMenuItem(
                        id: i, title: basicTypes.values.toList()[i]),
                ],
                onChanged: (value) {
                  selectedMenuItem.value = value;
                },
              ),
            ),
            //button to add new, delete selected
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red),
                onPressed: () {
                  onDelete(() async {
                    return await deleteSelected(null);
                  }, showError: false);
                },
                child: const Text("Delete Selected")),
            ElevatedButton(
                onPressed: () {
                  onEdit((p0) => CreateBasicPopup(model: p0), null);
                },
                child: const Text("Add New")),
          ],
        ),
        focusNode: focusNode,
        onLoaded: onLoaded,
        columns: columns,
        rows: rows);
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
            enableRowChecked: true,
            title: "Title",
            field: "title",
            type: PlutoColumnType.text()),
        PlutoColumn(title: "Type", field: 'type', type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Description",
            field: "message",
            type: PlutoColumnType.text()),
        PlutoColumn(title: "Date", field: "date", type: PlutoColumnType.date()),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 80,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onEdit: () {
                onEdit((p0) => CreateBasicPopup(model: p0),
                    rendererContext.cell.value);
              },
              onDelete: () {
                onDelete(() async {
                  return await deleteSelected(rendererContext.row);
                }, showError: false);
              },
            );
          },
        ),
      ];

  @override
  PlutoRow buildRow(BasicMd model) {
    String message = "";

    try {
      message = Document.fromJson(jsonDecode(model.message)).toPlainText();
    } catch (e) {
      message = model.message;
    }

    return PlutoRow(cells: {
      "title": PlutoCell(value: model.title),
      "type": PlutoCell(value: model.type),
      "message": PlutoCell(value: message),
      "date": PlutoCell(value: model.uploadDate),
      "action": PlutoCell(value: model),
    });
  }

  @override
  Future<List<BasicMd>?> fetch() async {
    final success = await dependencyManager.firestore.getBasics(
      filterKey: "type",
      filterValue: selectedMenuItem.value.title,
    );
    if (success.isLeft) {
      return success.left;
    } else {
      context.showError("Something went wrong");
    }
    return null;
  }

  Future<bool> deleteSelected(PlutoRow? singleRow) async {
    final selected = [...stateManager!.checkedRows];
    if (singleRow != null) {
      selected.clear();
      selected.add(singleRow);
    }
    if (selected.isEmpty) {
      return false;
    }
    final List<String> delFailed = [];
    for (final row in selected) {
      final id = row.cells['action']!.value.id;
      final res = await dependencyManager.firestore.deleteBasic(id);
      if (res.isLeft) {
        delFailed.add(row.cells['title']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }

  // void onReview(BasicMd model) {
  //   context.futureLoading(() async {
  //     final success = await dependencyManager.firestore
  //         .createOrUpdateBasic(
  //             model: model.copyWith(isReviewedByAdmin: true), images: []);
  //     if (success.isRight) {
  //       final l = await fetch();
  //       setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
  //     } else if (success.isLeft) {
  //       context.showError(success.left);
  //     } else {
  //       context.showError("Something went wrong");
  //     }
  //   });
  // }
}
