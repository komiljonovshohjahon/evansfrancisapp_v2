// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/presentation/global_widgets/spaced_row.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:pluto_grid/pluto_grid.dart';

import 'create_new.dart';

class PraiseReportView extends StatefulWidget {
  const PraiseReportView({super.key});

  @override
  State<PraiseReportView> createState() => _PraiseReportViewState();
}

class _PraiseReportViewState extends State<PraiseReportView>
    with TableFocusNodeMixin<PraiseReportView, PraiseReportMd> {
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
                  onEdit((p0) => CreatePraiseReportPopup(model: p0), null);
                },
                child: const Text("Add New")),
          ],
        ),
        focusNode: focusNode,
        onLoaded: onLoaded,
        columns: columns,
        rowColorCallback: (p0) {
          switch (p0.row.cells['action']!.value.isReviewedByAdmin) {
            case false:
              return context.colorScheme.secondary.withOpacity(0.05);
          }
          return Colors.white;
        },
        rows: rows);
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
            enableRowChecked: true,
            title: "Title",
            field: "title",
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Description",
            field: "message",
            type: PlutoColumnType.text()),
        PlutoColumn(title: "Date", field: "date", type: PlutoColumnType.date()),
        PlutoColumn(
          width: 80,
          title: "Review",
          field: "review",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            final model =
                rendererContext.row.cells['action']!.value as PraiseReportMd;
            return TextButton(
                onPressed: model.isReviewedByAdmin
                    ? null
                    : () {
                        onReview(model);
                      },
                child: const Text("Review"));
          },
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 80,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onEdit: () {
                onEdit((p0) => CreatePraiseReportPopup(model: p0),
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
  PlutoRow buildRow(PraiseReportMd model) {
    String message = "";

    try {
      message = Document.fromJson(jsonDecode(model.description)).toPlainText();
    } catch (e) {
      message = model.description;
    }

    return PlutoRow(cells: {
      "title": PlutoCell(value: model.title),
      "message": PlutoCell(value: message),
      "date": PlutoCell(value: model.uploadedAt),
      "review": PlutoCell(value: model.isReviewedByAdmin ? "Reviewed" : ""),
      "action": PlutoCell(value: model),
    });
  }

  @override
  Future<List<PraiseReportMd>?> fetch() async {
    final success = await dependencyManager.firestore.getPraiseReports();
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
      final res = await dependencyManager.firestore.deletePraiseReport(id);
      if (res.isLeft) {
        delFailed.add(row.cells['title']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }

  void onReview(PraiseReportMd model) {
    context.futureLoading(() async {
      final success = await dependencyManager.firestore
          .createOrUpdatePraiseReport(
              model: model.copyWith(isReviewedByAdmin: true), images: []);
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
}
