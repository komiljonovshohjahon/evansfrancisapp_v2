// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class CreatePraiseReportPopup extends StatefulWidget {
  final PraiseReportMd? model;

  const CreatePraiseReportPopup({super.key, this.model});

  @override
  State<CreatePraiseReportPopup> createState() =>
      _CreatePraiseReportPopupState();
}

class _CreatePraiseReportPopupState extends State<CreatePraiseReportPopup>
    with FormsMixin<CreatePraiseReportPopup> {
  List<PlatformFile?> images = List.generate(10, (index) => null);

  bool get isEdit => widget.model != null;

  final DependencyManager dependencyManager = DependencyManager.instance;

  QuillController controller = QuillController.basic();

  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (isEdit) {
      controller1.text = widget.model!.title;
      try {
        var myJSON = jsonDecode(widget.model!.description);
        controller = QuillController(
            document: Document.fromJson(myJSON),
            selection: const TextSelection.collapsed(offset: 0));
        // ignore: empty_catches
      } catch (e) {}
    }
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((value) async {
      if (!isEdit) return;
      context.futureLoading(() async {
        //get images
        final imageDataList = await dependencyManager.fireStorage
            .getImages("${FirestoreDep.praiseReportCn}/${widget.model!.id}");

        if (imageDataList.isRight) {
          //set images
          for (int i = 0; i < imageDataList.right.items.length; i++) {
            final item = imageDataList.right.items[i];
            final imageData = await item.getData();
            images[int.parse(item.name)] = PlatformFile(
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
                  .createOrUpdatePraiseReport(
                sendNotification: true,
                model: PraiseReportMd.init().copyWith(
                  id: widget.model?.id,
                  title: controller1.text,
                  uploadedBy: widget.model?.uploadedBy,
                  uploadedAt: widget.model?.uploadedAt,
                  isReviewedByAdmin: widget.model?.isReviewedByAdmin,
                  description:
                      jsonEncode(controller.document.toDelta().toJson()),
                ),
                images: images
                    .where((element) => element != null)
                    .map((e) => e!.bytes!)
                    .toList(),
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
              width: MediaQuery.of(context).size.width * 0.5,
              title: isEdit ? 'Edit Praise Report' : 'Add Praise Report',
              items: [
                DefaultCardItem(
                  title: "Title",
                  maxLines: 2,
                  controller: controller1,
                  isRequired: true,
                ),
                DefaultCardItem(
                  customWidget: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 250,
                      child: Scrollbar(
                        interactive: true,
                        thumbVisibility: true,
                        trackVisibility: true,
                        controller: scrollController,
                        child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              ///generate buttons if there is no image which will select image
                              final image = images[index];
                              return Stack(
                                children: [
                                  // if image == null then show button and select image
                                  //else show image
                                  if (image == null)
                                    Positioned(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles(
                                                  type: FileType.image,
                                                  allowMultiple: false);
                                          if (result != null) {
                                            if (isEdit) {
                                              context.futureLoading(() async {
                                                try {
                                                  final res =
                                                      await DependencyManager
                                                          .instance.fireStorage
                                                          .uploadImage(
                                                              data: result.files
                                                                  .first.bytes!,
                                                              path:
                                                                  "${FirestoreDep.praiseReportCn}/${widget.model!.id}/$index");
                                                  if (res.isRight) {
                                                    images[index] =
                                                        result.files.first;
                                                    setState(() {});
                                                  } else {
                                                    context.showError(
                                                        "Failed to upload image");
                                                  }
                                                } catch (e) {
                                                  context.showError(
                                                      "Failed to upload image");
                                                }
                                              });
                                              return;
                                            }
                                            images[index] = result.files.first;
                                            setState(() {});
                                          }
                                        },
                                        child: const Text("Select Image"),
                                      ),
                                    )
                                  else
                                    Positioned(
                                      child: Image.memory(
                                        image.bytes!,
                                        width: 300,
                                        height: 200,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  if (image != null)
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          if (isEdit) {
                                            final imagePath =
                                                "${FirestoreDep.praiseReportCn}/${widget.model!.id}/$index";
                                            try {
                                              dependencyManager.fireStorage
                                                  .deleteImage(imagePath)
                                                  .then((value) {
                                                if (value.isRight) {
                                                  images[index] = null;
                                                  setState(() {});
                                                } else {
                                                  context.showError(
                                                      "Failed to delete image");
                                                }
                                              });
                                            } catch (e) {
                                              context.showError(
                                                  "Failed to delete image");
                                            }
                                          } else {
                                            images[index] = null;
                                            setState(() {});
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                ],
                              );
                            }),
                      )),
                ),
                DefaultCardItem(
                    customWidget: DefaultQuill(
                        title: "Description", controller: controller))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
