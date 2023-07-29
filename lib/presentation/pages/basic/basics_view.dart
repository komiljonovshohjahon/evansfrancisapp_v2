// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BasicsView extends StatefulWidget {
  final String type;
  final String? collection;
  final String? documentId;
  const BasicsView(
      {super.key, required this.type, this.collection, this.documentId});

  @override
  State<BasicsView> createState() => _BasicsViewState();
}

class _BasicsViewState extends State<BasicsView> {
  final deps = DependencyManager.instance;

  String? get collection => widget.collection;
  String? get documentId => widget.documentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      context.futureLoading(() async {
        if (collection != null && documentId != null) {
          final item = await deps.firestore
              .findByCollectionAndDocumentId<BasicMd>(
                  collection: collection!,
                  documentId: documentId!,
                  fromJson: (p0) => BasicMd.fromJson(p0));
          if (item != null) {
            onCardTap(item);
          } else {
            context.showError("Cannot find document");
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: deps.firestore.getCollectionBasedListStream<BasicMd>(
          collection: FirestoreDep.basicCn,
          fromJson: (p0) => BasicMd.fromJson(p0),
          toJson: (p0) => p0.toJson(),
          orderByKey: "type",
          orderByValue: widget.type,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data ?? <BasicMd>[];

          if (list.isEmpty) return const Center(child: Text("No data found"));

          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = list[index];
              // logger(deps.fireStorage.storage);
              return DefaultListTile(
                heroTag: item.id,
                title: item.title,
                image: DefaultCachedFirebaseImageProvider(
                    "${FirestoreDep.basicCn}/${item.id}/0"),
                subtitle: DateFormat.yMMMEd().format(item.uploadDate),
                onTap: () {
                  onCardTap(item);
                },
              );
            },
          );
        });
  }

  void onCardTap(BasicMd item) {
    context.openWithHeroAnimation(DefaultMultiImagePopup(
      title: item.title,
      heroTag: item.id,
      description: item.message,
      decodeDescription: true,
      images: [
        for (int i = 0; i < 30; i++)
          DefaultCachedFirebaseImageProvider(
              "${FirestoreDep.basicCn}/${item.id}/$i")
      ],
    ));
  }
}
