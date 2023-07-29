// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/presentation/global_widgets/spaced_row.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'create_new.dart';

class SocialMediaView extends StatefulWidget {
  const SocialMediaView({super.key});

  @override
  State<SocialMediaView> createState() => _SocialMediaViewState();
}

class _SocialMediaViewState extends State<SocialMediaView>
    with TableFocusNodeMixin<SocialMediaView, BasicMd> {
  @override
  Widget build(BuildContext context) {
    return DefaultTable(
        headerEnd: SpacedRow(
          horizontalSpace: 10,
          children: [
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
                  onEdit((p0) => CreateSocialMediaPopup(model: p0), null);
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
            title: "Name",
            enableRowChecked: true,
            field: "title",
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Url", field: "message", type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 80,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onEdit: () {
                onEdit((p0) => CreateSocialMediaPopup(model: p0),
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
    return PlutoRow(cells: {
      "title": PlutoCell(value: model.type),
      "message": PlutoCell(value: model.message),
      "action": PlutoCell(value: model),
    });
  }

  @override
  Future<List<BasicMd>?> fetch() async {
    final success = await dependencyManager.firestore.getSocialMedia();
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
      final res = await dependencyManager.firestore.deleteSocialMedia(id);
      if (res.isLeft) {
        delFailed.add(row.cells['title']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }
}
