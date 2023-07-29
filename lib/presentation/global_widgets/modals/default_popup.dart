import 'dart:convert';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultPopup extends StatefulWidget {
  final String? title;
  final String? description;
  final bool decodeDescription;
  final ImageProvider? image;
  final String? heroTag;
  const DefaultPopup(
      {super.key,
      this.title,
      this.description,
      this.heroTag,
      this.decodeDescription = false,
      this.image});

  @override
  State<DefaultPopup> createState() => _DefaultPopupState();
}

class _DefaultPopupState extends State<DefaultPopup> {
  DependencyManager deps = DependencyManager.instance;
  q.QuillController controller = q.QuillController.basic();

  String? get title => widget.title;
  String? get description => widget.description;
  bool get decodeDescription => widget.decodeDescription;
  ImageProvider? get image => widget.image;

  @override
  void initState() {
    if (decodeDescription && description != null) {
      try {
        var myJSON = jsonDecode(description!);
        controller = q.QuillController(
            document: q.Document.fromJson(myJSON),
            selection: const TextSelection.collapsed(offset: 0));
        // ignore: empty_catches
      } catch (e) {}
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.only(left: 36.w, right: 16.w),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.all(20.w),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      title: Row(
        children: [
          if (title != null)
            SizedBox(
              width: context.width * 0.7,
              child: Text(title!),
            )
          else
            const SizedBox.shrink(),
          const Spacer(),
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close))
        ],
      ),
      children: [
        //image
        if (image != null)
          Hero(
            tag: widget.heroTag ?? '',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.r),
              child: Image(
                image: image!,
                fit: BoxFit.fill,
                height: 500.h,
                width: context.width * 0.8,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        SizedBox(height: 20.h),
        //description
        if (decodeDescription &&
            description != null &&
            !controller.document.isEmpty())
          q.QuillEditor.basic(controller: controller, readOnly: true),
      ],
    );
  }
}
