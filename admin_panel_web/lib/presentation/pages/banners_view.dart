// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/global_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BannersView extends StatefulWidget {
  const BannersView({super.key});

  @override
  State<BannersView> createState() => _BannersViewState();
}

class _BannersViewState extends State<BannersView> {
  final DependencyManager dependencyManager = DependencyManager.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: DefaultCard(title: "Banners", items: [
          for (int i = 0; i < 5; i++)
            DefaultCardItem(
                customWidget: SpacedRow(
              horizontalSpace: 8,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    child: Text("Select Banner ${i + 1}"),
                    onPressed: () async {
                      final res = await FilePicker.platform.pickFiles(
                          type: FileType.image, allowMultiple: false);
                      if (res == null) return;
                      //todo First upload and then update UI
                      context.futureLoading(() async {
                        final uploadRes = await dependencyManager.fireStorage
                            .uploadData(
                                data: res.files.first.bytes!,
                                path: "banners/banner$i");
                        if (uploadRes.isRight) {
                          print("Uploaded");
                          setState(() {});
                        } else {
                          context.showError(uploadRes.left);
                        }
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    FutureBuilder(
                      future: dependencyManager.fireStorage
                          .getReference("banners/banner$i")
                          .getDownloadURL(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CachedNetworkImage(
                              imageUrl: snapshot.data.toString(),
                              width: 200,
                              height: 200,
                              placeholder: (context, url) => const SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              errorWidget: (context, url, error) {
                                logger(error.toString());
                                return const SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: Icon(Icons.error),
                                  ),
                                );
                              });
                        }
                        return const SizedBox();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        //todo First delete and then update UI
                        context.futureLoading(() async {
                          await dependencyManager.fireStorage
                              .getReference("banners/banner$i")
                              .delete();
                          Logger.i("Deleted banner $i");
                          setState(() {});
                        });
                      },
                    ),
                  ],
                ),
              ],
            ))
        ]),
      ),
    );
  }
}
