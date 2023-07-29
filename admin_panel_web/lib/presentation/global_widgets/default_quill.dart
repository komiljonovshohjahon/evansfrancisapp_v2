import 'package:admin_panel_web/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class DefaultQuill extends StatelessWidget {
  final QuillController controller;
  final String? title;
  const DefaultQuill({super.key, required this.controller, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? 'Message', style: context.textTheme.headlineMedium),
        const SizedBox(height: 10),
        QuillToolbar.basic(
            showSearchButton: false,
            showIndent: false,
            showAlignmentButtons: false,
            showInlineCode: false,
            showBackgroundColorButton: false,
            showCodeBlock: false,
            showSuperscript: false,
            showSubscript: false,
            showUndo: false,
            showRedo: false,
            showListCheck: false,
            showDirection: false,
            showFontFamily: false,
            controller: controller),
        const Divider(color: Colors.black),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5)),
          width: context.width,
          height: 300,
          child: QuillEditor.basic(
            controller: controller,
            readOnly: false, // true for view only mode
          ),
        )
      ],
    );
  }
}
