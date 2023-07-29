// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PrayerRequestsView extends StatefulWidget {
  const PrayerRequestsView({super.key});

  @override
  State<PrayerRequestsView> createState() => _PrayerRequestsViewState();
}

class _PrayerRequestsViewState extends State<PrayerRequestsView>
    with TableFocusNodeMixin<PrayerRequestsView, PrayerRequestMd> {
  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: 'Full name',
          enableRowChecked: true,
          field: 'name',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: 'Email',
          field: 'email',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: 'Contact',
          field: 'contact',
          width: 120,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: 'Country Code',
          field: 'countryCode',
          width: 40,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: 'State',
          field: 'State',
          width: 120,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: 'City',
          field: 'city',
          width: 120,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: 'Prayer For',
          field: 'prayerFor',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: 'Message',
          field: 'message',
          width: 100,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultTooltipWidget(
                title: "View", context: context);
          },
        ),
        PlutoColumn(
          width: 80,
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            final model =
                rendererContext.row.cells['action']!.value as PrayerRequestMd;
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

  void onReview(PrayerRequestMd model) {
    context.futureLoading(() async {
      final success = await dependencyManager.firestore
          .createOrUpdatePrayerRequest(
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
        final res = await dependencyManager.firestore.deletePrayerRequest(id);
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
  PlutoRow buildRow(PrayerRequestMd model) {
    return PlutoRow(cells: {
      'name': PlutoCell(value: model.fullname),
      'email': PlutoCell(value: model.email),
      'contact': PlutoCell(value: model.contactNo),
      'countryCode': PlutoCell(value: model.countryCode),
      'State': PlutoCell(value: model.state),
      'city': PlutoCell(value: model.city),
      'prayerFor': PlutoCell(value: model.prayerRequestName),
      'message': PlutoCell(value: model.message),
      'action': PlutoCell(value: model),
    });
  }

  @override
  Future<List<PrayerRequestMd>?> fetch() async {
    final success = await dependencyManager.firestore.getPrayerRequests();
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
