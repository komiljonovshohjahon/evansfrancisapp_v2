// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DailyDevotionView extends StatefulWidget {
  final String? collection;
  final String? documentId;
  const DailyDevotionView({super.key, this.collection, this.documentId});

  @override
  State<DailyDevotionView> createState() => _DailyDevotionViewState();
}

class _DailyDevotionViewState extends State<DailyDevotionView> {
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
              .findByCollectionAndDocumentId<DevotionMd>(
                  collection: collection!,
                  documentId: documentId!,
                  fromJson: (p0) => DevotionMd.fromJson(p0));
          if (item != null) {
            onCardTap(item);
          } else {
            context.showError("Cannot find devotion");
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (devotions.isEmpty) return const Center(child: Text("No data found"));
    return StreamBuilder(
        stream: deps.firestore.getCollectionBasedListStream<DevotionMd>(
            collection: FirestoreDep.devotionCn,
            fromJson: (p0) => DevotionMd.fromJson(p0),
            toJson: (p0) => p0.toJson()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final devotions = (snapshot.data ?? [])
              .where((element) => element.isVisible && !element.isScripture)
              .toList();

          if (devotions.isEmpty) {
            return const Center(child: Text("No data found"));
          }

          return ListView.builder(
            itemCount: devotions.length,
            itemBuilder: (context, index) {
              final item = devotions[index];
              // logger(deps.fireStorage.storage);
              return Dismissible(
                key: Key(item.id),
                onDismissed: (direction) {
                  //delete item
                  context.futureLoading(() async {
                    final res =
                        await deps.firestore.deleteDailyDevotion(item.id);
                    if (res.isLeft) {
                      context.showError(res.left);
                      return;
                    }
                    devotions.removeAt(index);
                    setState(() {});
                  });
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.delete_outline_outlined, color: Colors.white),
                      Icon(Icons.delete_outline_outlined, color: Colors.white),
                    ],
                  ),
                ),
                confirmDismiss: (direction) {
                  return showDialog(
                      context: context,
                      builder: (context) => const ConfirmDialog(
                          content: "Are you sure you want to delete?"));
                },
                child: DefaultListTile(
                  heroTag: item.id,
                  title: item.title,
                  image: DefaultCachedFirebaseImageProvider(
                      "${FirestoreDep.devotionCn}/${item.id}"),
                  subtitle: DateFormat.yMMMEd().format(item.uploadedAt!),
                  onTap: () {
                    onCardTap(item);
                  },
                ),
              );
            },
          );
        });
  }

  void onCardTap(DevotionMd item) {
    context.openWithHeroAnimation(DefaultPopup(
      title: item.title,
      heroTag: item.id,
      description: item.message,
      decodeDescription: true,
      image: DefaultCachedFirebaseImageProvider(
          "${FirestoreDep.devotionCn}/${item.id}"),
    ));
  }
}
