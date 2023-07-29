import 'dart:convert';

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/default_firebase_image_provider.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DevotionViewDialog extends StatefulWidget {
  final DevotionMd model;
  final String descriptionTitle;
  const DevotionViewDialog(
      {super.key, required this.model, this.descriptionTitle = 'Message'});

  @override
  State<DevotionViewDialog> createState() => _DevotionViewDialogState();
}

class _DevotionViewDialogState extends State<DevotionViewDialog> {
  DependencyManager deps = DependencyManager.instance;
  late final DevotionMd model;
  q.QuillController controller = q.QuillController.basic();

  Future<Uint8List?> getImage(String id) async {
    final imageDataList =
        await deps.fireStorage.getImages(FirestoreDep.devotionCn);
    if (imageDataList.isRight) {
      //set images
      for (int i = 0; i < imageDataList.right.items.length; i++) {
        final item = imageDataList.right.items[i];
        if (item.name != id) continue;
        return await item.getData();
      }
    }
    return null;
  }

  @override
  void initState() {
    model = widget.model;
    try {
      var myJSON = jsonDecode(widget.model.message);
      controller = q.QuillController(
          document: q.Document.fromJson(myJSON),
          selection: const TextSelection.collapsed(offset: 0));
      // ignore: empty_catches
    } catch (e) {}
    super.initState();
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
        if (model.message.isEmpty)
          Text("No message found", style: context.textTheme.bodyLarge),
        if (model.message.isNotEmpty)
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
        Hero(
          tag: model.id,
          child: Image(
            image: DefaultCachedFirebaseImageProvider(
                "${FirestoreDep.devotionCn}/${model.id}"),
            width: 300.w,
            height: 300.h,
          ),
        )
      ],
    );
  }
}
