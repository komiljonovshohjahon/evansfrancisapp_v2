// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class PastoralCareCreateNewPopup extends StatefulWidget {
  final ContentMd? model;

  const PastoralCareCreateNewPopup({super.key, this.model});

  @override
  State<PastoralCareCreateNewPopup> createState() =>
      _PastoralCareCreateNewPopupState();
}

class _PastoralCareCreateNewPopupState extends State<PastoralCareCreateNewPopup>
    with FormsMixin<PastoralCareCreateNewPopup> {
  late ContentMd model;

  List<q.QuillController> qControllers = [];

  bool get isNew => model.isNew;

  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    model = widget.model ?? ContentMd.init();
    if (!isNew) {
      for (final content in model.content) {
        final contr = q.QuillController(
            document: q.Document.fromJson(jsonDecode(content.description)),
            selection: const TextSelection.collapsed(offset: 0));
        qControllers.add(contr);
      }
      controller1.text = model.title;
    }
    super.initState();
    controller1.addListener(() {
      model = model.copyWith(title: controller1.text);
    });
  }

  @override
  void dispose() {
    for (final controller in qControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(!isNew ? "Edit" : "New"),
          const Spacer(),
          TextButton.icon(
              onPressed: () {
                model = model.addContent(BasicContentMd.init());
                final contr = q.QuillController(
                    document: q.Document(),
                    selection: const TextSelection.collapsed(offset: 0));
                qControllers.add(contr);
                updateUI();
              },
              icon: const Icon(Icons.add),
              label: const Text("Add New Dropdown")),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          child: const Text("Save"),
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            context.futureLoading(() async {
              final content = [...model.content];
              for (int i = 0; i < content.length; i++) {
                content[i] = content[i].copyWith(
                  description:
                      jsonEncode(qControllers[i].document.toDelta().toJson()),
                );
              }
              model = model.copyWith(content: content);
              final res = await DependencyManager.instance.firestore
                  .createOrUpdatePastoralCare(
                model: model,
                sendNotification: true,
              );
              if (res.isLeft) {
                context.showError(res.left);
              } else {
                context.pop(true);
              }
            });
          },
        ),
      ],
      scrollable: true,
      content: Form(
        key: formKey,
        child: DefaultCard(
          title: '',
          items: [
            DefaultCardItem(
              title: "Dropdown Name",
              controller: controller1,
              isRequired: true,
            ),
            for (int i = 0; i < model.content.length; i++)
              DefaultCardItem(
                  customWidget: ExpansionTile(
                leading: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    model = model.removeContent(i);
                    qControllers.removeAt(i);
                    updateUI();
                  },
                ),
                collapsedBackgroundColor:
                    context.colorScheme.primary.withOpacity(.2),
                backgroundColor: context.colorScheme.primary.withOpacity(.2),
                title: Text("Dropdown ${i + 1}"),
                children: [
                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //     labelText: "Title",
                  //     labelStyle: TextStyle(color: Colors.black, fontSize: 32),
                  //     border: InputBorder.none,
                  //   ),
                  //   initialValue: model.content[i].title,
                  //   onChanged: (value) {
                  //     model.content[i] =
                  //         model.content[i].copyWith(title: value);
                  //   },
                  // ),
                  // const SizedBox(height: 10),
                  DefaultQuill(
                    controller: qControllers[i],
                    title: "More info",
                  )
                ],
              )),
          ],
        ),
      ),
    );
  }
}
