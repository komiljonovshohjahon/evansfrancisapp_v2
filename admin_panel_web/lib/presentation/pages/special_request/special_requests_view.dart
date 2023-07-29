// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SpecialRequestsView extends StatefulWidget {
  const SpecialRequestsView({super.key});

  @override
  State<SpecialRequestsView> createState() => _SpecialRequestsViewState();
}

class _SpecialRequestsViewState extends State<SpecialRequestsView>
    with TableFocusNodeMixin<SpecialRequestsView, SpecialRequestMd> {
  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: 'Special Request Type',
          field: 'requestType',
          enableRowChecked: true,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: 'Description',
          field: 'message',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          width: 80,
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            final model =
                rendererContext.row.cells['action']!.value as SpecialRequestMd;
            return TextButton(
                onPressed: model.isReviewedByAdmin
                    ? null
                    : () {
                        onReview(model);
                      },
                child: const Text("Review"));
          },
        )
      ];

  void onReview(SpecialRequestMd model) {
    context.futureLoading(() async {
      final success = await dependencyManager.firestore
          .createOrUpdateSpecialRequest(
              model: model.copyWith(isReviewedByAdmin: true));
      if (success.isRight) {
        final l = await fetch();
        setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
      } else if (success.isLeft) {
        context.showError(success.left);
      } else {
        context.showError("Something went wrong");
      }
    });
  }

  void deleteSelected(PlutoRow? singleRow) {
    onDelete(() async {
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
        final res = await dependencyManager.firestore.deleteSpecialRequest(id);
        if (res.isLeft) {
          delFailed.add(row.cells['name']!.value);
        }
      }
      if (delFailed.isNotEmpty) {
        context.showError("Failed to delete ${delFailed.join(", ")}");
      }
      return delFailed.isEmpty;
    }, showError: false);
  }

  @override
  PlutoRow buildRow(SpecialRequestMd model) {
    return PlutoRow(cells: {
      'requestType': PlutoCell(value: model.requestName),
      'message': PlutoCell(value: model.description),
      'action': PlutoCell(value: model)
    });
  }

  @override
  Future<List<SpecialRequestMd>?> fetch() async {
    final success = await dependencyManager.firestore.getSpecialRequests();
    if (success.isLeft) {
      return success.left;
    } else if (success.isRight) {
      context.showError(success.right);
    } else {
      context.showError('Something went wrong');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
        rowColorCallback: (p0) {
          switch (p0.row.cells['action']!.value.isReviewedByAdmin) {
            case false:
              return context.colorScheme.secondary.withOpacity(0.05);
          }
          return Colors.white;
        },
        headerEnd: Row(
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  deleteSelected(null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.delete),
                label: const Text("Delete Selected")),
          ],
        ),
        focusNode: focusNode,
        onLoaded: onLoaded,
        columns: columns,
        rows: rows);
  }
}
