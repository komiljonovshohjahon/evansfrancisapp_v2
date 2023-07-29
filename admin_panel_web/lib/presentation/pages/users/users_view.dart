// ignore_for_file: use_build_context_synchronously
import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView>
    with TableFocusNodeMixin<UsersView, UserMd> {
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
        focusNode: focusNode,
        onLoaded: onLoaded,
        columns: columns,
        rows: rows);
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
            // enableRowChecked: true,
            title: "Name",
            field: "name",
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Email", field: "email", type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Phone Number",
            field: "phoneNumber",
            type: PlutoColumnType.text()),
        PlutoColumn(title: "PIN", field: "pin", type: PlutoColumnType.text()),
        PlutoColumn(
            width: 60,
            title: "Admin",
            field: "isAdmin",
            textAlign: PlutoColumnTextAlign.center,
            type: PlutoColumnType.text()),
        PlutoColumn(
            width: 60,
            title: "Banned",
            field: "isBanned",
            textAlign: PlutoColumnTextAlign.center,
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 80,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            final model = rendererContext.cell.value as UserMd;
            return PopupMenuButton(
              offset: const Offset(0, 40),
              padding: const EdgeInsets.all(0),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: "ban",
                    child: Text(model.isBanned ? "Unban" : "Ban" " User"),
                  ),
                  PopupMenuItem(
                    value: "admin",
                    child: Text(!model.isAdmin ? "Make Admin" : "Remove Admin"),
                  ),
                  if (model.isReviewedByAdmin == false)
                    const PopupMenuItem(
                      value: "review",
                      child: Text("Review"),
                    ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case "ban":
                    onBanUser(model, !model.isBanned);
                    break;
                  case "admin":
                    onMakeAdmin(model, !model.isAdmin);
                    break;
                  case "review":
                    onReviewUser(model);
                    break;
                }
              },
            );
          },
        ),
      ];

  @override
  PlutoRow buildRow(UserMd model) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: model.name),
      "email": PlutoCell(value: model.email),
      "phoneNumber": PlutoCell(value: model.phone),
      "pin": PlutoCell(value: model.pin),
      "isAdmin": PlutoCell(value: model.isAdmin ? "✔️" : ""),
      "isBanned": PlutoCell(value: model.isBanned ? "✔️" : ""),
      "action": PlutoCell(value: model)
    });
  }

  @override
  Future<List<UserMd>?> fetch() async {
    final success = await dependencyManager.firestore.getUsers();
    if (success.isLeft) {
      return success.left;
    } else {
      context.showError("Something went wrong");
    }
    return null;
  }

  void onBanUser(UserMd model, bool ban) {
    context.futureLoading(() async {
      final success = await dependencyManager.firestore
          .updateUserData("isBanned", ban, model.id);
      if (success.isLeft) {
        //error
        context.showError(success.left);
      } else if (success.isRight) {
        //success
        final l = await fetch();
        setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
        context
            .showSuccess("User ${model.name} ${ban ? "banned" : "unbanned"}");
      } else {
        //no change
        context.showError("Something went wrong");
      }
    });
  }

  void onMakeAdmin(UserMd model, bool isAdmin) {
    context.futureLoading(() async {
      final success = await dependencyManager.firestore
          .updateUserData("isAdmin", isAdmin, model.id);
      if (success.isLeft) {
        //error
        context.showError(success.left);
      } else if (success.isRight) {
        //success
        final l = await fetch();
        setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
        context.showSuccess(
            "User ${model.name} ${isAdmin ? "is admin now" : "is not admin anymore"}");
      } else {
        //no change
        context.showError("Something went wrong");
      }
    });
  }

  void onReviewUser(UserMd model) {
    context.futureLoading(() async {
      final success = await dependencyManager.firestore
          .updateUserData("isReviewedByAdmin", true, model.id);
      if (success.isLeft) {
        //error
        context.showError(success.left);
      } else if (success.isRight) {
        //success
        final l = await fetch();
        setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
      } else {
        //no change
        context.showError("Something went wrong");
      }
    });
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
      final res = await dependencyManager.firestore.deleteCeremony(id);
      if (res.isLeft) {
        delFailed.add(row.cells['name']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }
}
