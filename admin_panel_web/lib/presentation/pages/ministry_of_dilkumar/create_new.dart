// ignore_for_file: use_build_context_synchronously
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';

class CeremonyCreateNewPopup extends StatefulWidget {
  final YoutubeContentMd? model;
  const CeremonyCreateNewPopup({super.key, this.model});

  @override
  State<CeremonyCreateNewPopup> createState() => _CeremonyCreateNewPopupState();
}

class _CeremonyCreateNewPopupState extends State<CeremonyCreateNewPopup>
    with FormsMixin<CeremonyCreateNewPopup> {
  bool get isEdit => widget.model != null;

  @override
  void initState() {
    if (widget.model != null) {
      controller1.text = widget.model!.title;
      controller2.text = widget.model!.link;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Edit" : "Add"),
      actions: [
        ElevatedButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          child: const Text("Save"),
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            if (!isYouTubeLink(controller2.text)) {
              return context.showError("Please enter a valid youtube link");
            }
            context.futureLoading(() async {
              final res = await DependencyManager.instance.firestore
                  .createOrUpdateCeremony(
                      sendNotification: true,
                      model: YoutubeContentMd.init().copyWith(
                          id: widget.model?.id,
                          title: controller1.text,
                          link: controller2.text,
                          uploadedBy: widget.model?.uploadedBy,
                          uploadedAt: widget.model?.uploadedAt,
                          isUae: false));
              if (res.isLeft) {
                context.showError(res.left);
              } else {
                context.pop(true);
              }
            });
          },
        ),
      ],
      content: Form(
        key: formKey,
        child: DefaultCard(
          title: '',
          items: [
            DefaultCardItem(
              title: "Title",
              maxLines: 5,
              controller: controller1,
              isRequired: true,
            ),
            DefaultCardItem(
              title: "Link",
              controller: controller2,
              isRequired: true,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
