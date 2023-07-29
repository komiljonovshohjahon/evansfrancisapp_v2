import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultQuillViewer extends StatefulWidget {
  final String text;
  final double height;
  const DefaultQuillViewer({super.key, required this.text, this.height = 100});

  @override
  State<DefaultQuillViewer> createState() => _DefaultQuillViewerState();
}

class _DefaultQuillViewerState extends State<DefaultQuillViewer> {
  late final QuillController _controller;

  @override
  void initState() {
    try {
      var myJSON = jsonDecode(widget.text);
      _controller = QuillController(
          document: Document.fromJson(myJSON),
          selection: const TextSelection.collapsed(offset: 0));
      // ignore: empty_catches
    } catch (e) {}
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
        ),
        padding: EdgeInsets.all(2.w),
        width: double.infinity,
        height: widget.height,
        child: QuillEditor.basic(controller: _controller, readOnly: true));
  }
}
