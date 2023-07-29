import 'dart:convert';

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PraiseReportViewDialog extends StatefulWidget {
  final PraiseReportMd model;
  final String descriptionTitle;
  const PraiseReportViewDialog(
      {super.key, required this.model, this.descriptionTitle = 'Message'});

  @override
  State<PraiseReportViewDialog> createState() => _PraiseReportViewDialogState();
}

class _PraiseReportViewDialogState extends State<PraiseReportViewDialog> {
  DependencyManager deps = DependencyManager.instance;
  late final PraiseReportMd model;
  q.QuillController controller = q.QuillController.basic();

  final ScrollController _scrollController = ScrollController();

  Future<List<Uint8List?>> getImages(String id) async {
    final imageDataList =
        await deps.fireStorage.getImages("${FirestoreDep.praiseReportCn}/$id");
    final List<Uint8List?> images = [];
    if (imageDataList.isRight) {
      //set images
      for (int i = 0; i < imageDataList.right.items.length; i++) {
        final item = imageDataList.right.items[i];
        images.add(await item.getData());
      }
    }
    return images;
  }

  @override
  void initState() {
    model = widget.model;
    try {
      var myJSON = jsonDecode(widget.model.description);
      controller = q.QuillController(
          document: q.Document.fromJson(myJSON),
          selection: const TextSelection.collapsed(offset: 0));
      // ignore: empty_catches
    } catch (e) {}
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        children: [
          SizedBox(
              width: context.width * 0.8,
              child: Text(
                model.title,
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              )),
          const Spacer(),
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close))
        ],
      ),
      titlePadding: EdgeInsets.all(20.w),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.all(20.w),
      children: [
        Text(widget.descriptionTitle, style: context.textTheme.headlineSmall),
        if (model.description.isEmpty)
          Text("No description found", style: context.textTheme.bodyLarge),
        if (model.description.isNotEmpty)
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5)),
            width: context.width,
            height: 400.h,
            child: q.QuillEditor.basic(
              controller: controller,
              readOnly: true,
              // true for view only mode
            ),
          ),
        const SizedBox(height: 10),
        Text("Images", style: context.textTheme.headlineSmall),
        FutureBuilder<List<Uint8List?>>(
            future: getImages(model.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                final images = snapshot.data!;
                return SizedBox(
                  height: 200.h,
                  width: context.width,
                  child: Scrollbar(
                    controller: _scrollController,
                    trackVisibility: true,
                    thumbVisibility: true,
                    child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        itemBuilder: (context, index) {
                          final image = images[index];
                          return MaterialButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: SizedBox(
                                        width: context.width,
                                        child: image != null
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                          onPressed:
                                                              context.pop,
                                                          icon: const Icon(
                                                              Icons.close)),
                                                    ],
                                                  ),
                                                  Image.memory(
                                                    image,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: image != null
                                  ? Image.memory(
                                      image,
                                      width: 300.w,
                                      height: 300.h,
                                    )
                                  : const SizedBox(),
                            ),
                          );
                        }),
                  ),
                );
              }
              return const SizedBox();
            }),
      ],
    );
  }
}
