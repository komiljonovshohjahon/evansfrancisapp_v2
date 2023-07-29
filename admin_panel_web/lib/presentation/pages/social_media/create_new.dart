// ignore_for_file: use_build_context_synchronously


import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';

class CreateSocialMediaPopup extends StatefulWidget {
  final BasicMd? model;

  const CreateSocialMediaPopup({super.key, this.model});

  @override
  State<CreateSocialMediaPopup> createState() => _CreateSocialMediaPopupState();
}

class _CreateSocialMediaPopupState extends State<CreateSocialMediaPopup>
    with FormsMixin<CreateSocialMediaPopup> {
  bool get isEdit => widget.model != null;
  final DependencyManager dependencyManager = DependencyManager.instance;
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (isEdit) {
      // final found = socialMedia.values
      //     .toList()
      //     .firstWhere((element) => element['title'] == widget.model!.type);
      // selected1 = DefaultMenuItem(
      //     id: socialMedia.values.toList().indexOf(found),
      //     title: widget.model!.type);
      controller1.text = widget.model!.message;
      controller2.text = widget.model!.type;
    }
    super.initState();
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
                  .createOrUpdateSocialMedia(
                model: BasicMd.init().copyWith(
                  id: widget.model?.id,
                  type: controller2.text,
                  message: controller1.text.replaceAll(" ", ""),
                ),
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
              title: isEdit ? 'Edit' : 'Add',
              items: [
                // DefaultCardItem(
                //     title: "Type",
                //     isRequired: true,
                //     dropdown: DefaultCardDropdown(
                //       items: [
                //         for (int i = 0; i < socialMedia.length; i++)
                //           DefaultMenuItem(
                //             id: i,
                //             title: socialMedia.values.toList()[i]['title'],
                //             additionalId: socialMedia.values.toList()[i]
                //                 ['title'],
                //           ),
                //       ],
                //       additionalValueId: selected1?.title,
                //       onChanged: (value) {
                //         selected1 = value;
                //         setState(() {});
                //       },
                //     )),
                DefaultCardItem(
                  title: "Name",
                  controller: controller2,
                  isRequired: true,
                ),
                DefaultCardItem(
                  title: "Url",
                  maxLines: 2,
                  controller: controller1,
                  isRequired: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
