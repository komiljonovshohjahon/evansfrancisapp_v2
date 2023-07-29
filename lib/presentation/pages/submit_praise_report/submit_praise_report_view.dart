// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/global_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';

class SubmitPraiseReportView extends StatefulWidget {
  const SubmitPraiseReportView({super.key});

  @override
  State<SubmitPraiseReportView> createState() => _SubmitPraiseReportViewState();
}

const int _imageMaxLen = 10;

class _SubmitPraiseReportViewState extends State<SubmitPraiseReportView>
    with FormsMixin<SubmitPraiseReportView> {
  final List<PlatformFile> images = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: SpacedColumn(
          verticalSpace: 16.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 1.h),
            textField1(
                label: "Title",
                validator: (value) =>
                    value!.isEmpty ? "Please enter a title" : null),
            textField2(
                label: "Description",
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a description" : null),
            Wrap(
              runSpacing: 8.h,
              spacing: 8.w,
              children: [
                ...images.mapIndexed((i, e) => Stack(
                      children: [
                        MaterialButton(
                          shape: BeveledRectangleBorder(
                            side: BorderSide(
                              color: context.colorScheme.secondary,
                              width: 2.w,
                            ),
                          ),
                          onPressed: () async {
                            //replace current image
                            final result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            if (result != null) {
                              setState(() {
                                images[i] = result.files.first;
                              });
                            }
                          },
                          child: Image.file(File(e.path!),
                              width: 150.w, height: 150.h, fit: BoxFit.contain),
                        ),
                        //delete button on top right
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                images.removeAt(i);
                              });
                            },
                            child: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            if (images.length < _imageMaxLen)
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform
                      .pickFiles(type: FileType.image, allowMultiple: true);
                  if (result != null) {
                    setState(() {
                      images.addAll(result.files);
                      if (images.length > _imageMaxLen) {
                        images.removeRange(_imageMaxLen, images.length);
                        context.showError(
                            "You can only upload a maximum of 10 images");
                      }
                    });
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Images'),
              ),
            SizedBox(
              width: context.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.secondary,
                  foregroundColor: context.colorScheme.onSecondary,
                ),
                onPressed: submit,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    context.futureLoading(() async {
      final success =
          await DependencyManager.instance.firestore.createOrUpdatePraiseReport(
        model: PraiseReportMd.init().copyWith(
          title: controller1.text,
          description: controller2.text,
        ),
        images: [],
        mobileImages: images.map((e) => File(e.path!)).toList(),
      );
      if (success.isRight) {
        context.pop();
        context.showSuccess("Praise report submitted successfully");
      } else if (success.isLeft) {
        context.showError(success.left);
      } else {
        context.showError("Failed to submit");
      }
    });
  }
}
