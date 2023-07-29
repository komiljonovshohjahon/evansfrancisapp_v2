// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class CreateBasicPopup extends StatefulWidget {
  final BasicMd? model;

  const CreateBasicPopup({super.key, this.model});

  @override
  State<CreateBasicPopup> createState() => _CreateBasicPopupState();
}

class _CreateBasicPopupState extends State<CreateBasicPopup>
    with FormsMixin<CreateBasicPopup> {
  List<PlatformFile?> images = List.generate(30, (index) => null);

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
      selected1 = DefaultMenuItem(
          id: basicTypes.values.toList().indexOf(widget.model!.type),
          title: widget.model!.type);
      try {
        var myJSON = jsonDecode(widget.model!.message);
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
            .getImages("${FirestoreDep.basicCn}/${widget.model!.id}");

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
            if (selected1 == null) {
              context.showError("Please select category");
              return;
            }
            if (!formKey.currentState!.validate()) return;
            context.futureLoading(() async {
              final res = await DependencyManager.instance.firestore
                  .createOrUpdateBasic(
                sendNotification: true,
                model: BasicMd.init().copyWith(
                  id: widget.model?.id,
                  title: controller1.text,
                  message: jsonEncode(controller.document.toDelta().toJson()),
                  type: selected1?.title,
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
                    title: "Category",
                    isRequired: true,
                    dropdown: DefaultCardDropdown(
                      items: [
                        for (int i = 1; i < basicTypes.length; i++)
                          DefaultMenuItem(
                              id: i, title: basicTypes.values.toList()[i]),
                      ],
                      valueId: selected1?.id,
                      onChanged: (value) {
                        selected1 = value;
                        setState(() {});
                      },
                    )),
                DefaultCardItem(
                    customWidget: DefaultQuill(
                        title: "Description", controller: controller)),
                DefaultCardItem(
                  customWidget: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 250,
                      child: Scrollbar(
                        interactive: true,
                        thumbVisibility: true,
                        trackVisibility: true,
                        controller: scrollController,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (int i = 0; i < images.length; i++)

                                ///generate buttons if there is no image which will select image
                                Stack(
                                  children: [
                                    // if image == null then show button and select image
                                    //else show image
                                    if (images[i] == null)
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
                                                            .instance
                                                            .fireStorage
                                                            .uploadImage(
                                                                data: result
                                                                    .files
                                                                    .first
                                                                    .bytes!,
                                                                path:
                                                                    "${FirestoreDep.basicCn}/${widget.model!.id}/$i");
                                                    if (res.isRight) {
                                                      images[i] =
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
                                              images[i] = result.files.first;
                                              setState(() {});
                                            }
                                          },
                                          child: const Text("Select Image"),
                                        ),
                                      )
                                    else
                                      Positioned(
                                        child: Image.memory(
                                          images[i]!.bytes!,
                                          width: 300,
                                          height: 200,
                                          fit: BoxFit.contain,
                                          frameBuilder: (context, child, frame,
                                              wasSynchronouslyLoaded) {
                                            if (wasSynchronouslyLoaded) {
                                              return child;
                                            }
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: context
                                                        .colorScheme.primary),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: child,
                                            );
                                          },
                                        ),
                                      ),
                                    if (images[i] != null)
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            if (isEdit) {
                                              final imagePath =
                                                  "${FirestoreDep.basicCn}/${widget.model!.id}/$i";
                                              try {
                                                dependencyManager.fireStorage
                                                    .deleteImage(imagePath)
                                                    .then((value) {
                                                  if (value.isRight) {
                                                    images[i] = null;
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
                                              images[i] = null;
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
                                )
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
