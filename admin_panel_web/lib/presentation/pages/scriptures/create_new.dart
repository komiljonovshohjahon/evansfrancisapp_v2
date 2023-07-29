// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class CreateScripturePopup extends StatefulWidget {
  final DevotionMd? model;

  const CreateScripturePopup({super.key, this.model});

  @override
  State<CreateScripturePopup> createState() => _CreateScripturePopupState();
}

class _CreateScripturePopupState extends State<CreateScripturePopup>
    with FormsMixin<CreateScripturePopup> {
  PlatformFile? image;

  bool get isEdit => widget.model != null;

  final DependencyManager dependencyManager = DependencyManager.instance;

  QuillController controller = QuillController.basic();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (isEdit) {
      controller1.text = widget.model!.title;
      try {
        var myJSON = jsonDecode(widget.model!.message);
        controller = QuillController(
            document: Document.fromJson(myJSON),
            selection: const TextSelection.collapsed(offset: 0));
        selectedDate1 = widget.model!.scheduledAt;
        // ignore: empty_catches
      } catch (e) {}
    }
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((value) async {
      if (!isEdit) return;
      context.futureLoading(() async {
        //get images
        final imageDataList = await dependencyManager.fireStorage
            .getImages(FirestoreDep.devotionCn);

        if (imageDataList.isRight) {
          logger("path: ${imageDataList.right.items.length}");
          //set images
          for (int i = 0; i < imageDataList.right.items.length; i++) {
            final item = imageDataList.right.items[i];
            if (item.name != widget.model!.id) continue;
            final imageData = await item.getData();
            image = PlatformFile(
              name: item.name,
              size: imageData!.lengthInBytes,
              bytes: imageData,
            );
          }

          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        //Cancel button
        ElevatedButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          child: const Text("Add"),
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            context.futureLoading(() async {
              final res = await DependencyManager.instance.firestore
                  .createOrUpdateDevotion(
                sendNotification: selectedDate1 == null,
                model: DevotionMd.init().copyWith(
                  id: widget.model?.id,
                  uploadedBy: widget.model?.uploadedBy,
                  uploadedAt: widget.model?.uploadedAt,
                  title: controller1.text,
                  scheduledAt: selectedDate1,
                  message: jsonEncode(controller.document.toDelta().toJson()),
                  isScripture: true,
                ),
                image: image?.bytes,
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
        child: SpacedColumn(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalSpace: 20,
          children: [
            DefaultCard(
              title: isEdit ? 'Edit Scripture' : 'Add Scripture',
              items: [
                DefaultCardItem(
                  title: "Title",
                  controller: controller1,
                  isRequired: true,
                ),
                DefaultCardItem(
                  customWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: const Text("Select Image"),
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                              type: FileType.image, allowMultiple: false);
                          if (result == null) return;
                          if (isEdit) {
                            context.futureLoading(() async {
                              try {
                                final res = await DependencyManager
                                    .instance.fireStorage
                                    .uploadImage(
                                        data: result.files.first.bytes!,
                                        path:
                                            "${FirestoreDep.devotionCn}/${widget.model!.id}");
                                if (res.isRight) {
                                  image = result.files.first;
                                  setState(() {});
                                } else {
                                  context.showError("Failed to upload image");
                                }
                              } catch (e) {
                                context.showError("Failed to upload image");
                              }
                            });
                            return;
                          }
                          image = result.files.first;
                          setState(() {});
                        },
                      ),
                      if (image != null)
                        Image.memory(
                          image!.bytes!,
                          width: 200,
                          height: 200,
                        ),
                      if (image != null)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            if (isEdit) {
                              final imagePath =
                                  "${FirestoreDep.devotionCn}/${widget.model!.id}";
                              try {
                                dependencyManager.fireStorage
                                    .deleteImage(imagePath)
                                    .then((value) {
                                  if (value.isRight) {
                                    image = null;
                                    setState(() {});
                                  } else {
                                    context.showError("Failed to delete image");
                                  }
                                });
                              } catch (e) {
                                context.showError("Failed to delete image");
                              }
                              return;
                            }
                            image = null;
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                ),
                DefaultCardItem(
                    customWidget:
                        DefaultQuill(title: "Verse", controller: controller)),
                DefaultCardItem(
                  title: "Schedule Date",
                  simpleText:
                      selectedDate1?.toDateTimeWithDash ?? "Select Date",
                  onSimpleTextTapped: () {
                    showDatePicker(
                      context: context,
                      initialDate: selectedDate1 ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ).then((date) async {
                      //now select time and merge into DateTime
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time == null) return;
                      date = DateTime(date!.year, date.month, date.day,
                          time.hour, time.minute);
                      selectedDate1 = date;
                      setState(() {});
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
