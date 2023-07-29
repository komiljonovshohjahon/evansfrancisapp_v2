// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/utils/global_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youtube/youtube_thumbnail.dart';

import '../../global_widgets/widgets.dart';

class MinistryDilkumarView extends StatefulWidget {
  final String? collection;
  final String? documentId;
  const MinistryDilkumarView({super.key, this.collection, this.documentId});

  @override
  State<MinistryDilkumarView> createState() => _MinistryDilkumarViewState();
}

class _MinistryDilkumarViewState extends State<MinistryDilkumarView> {
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
              .findByCollectionAndDocumentId<YoutubeContentMd>(
                  collection: collection!,
                  documentId: documentId!,
                  fromJson: (p0) => YoutubeContentMd.fromJson(p0));
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
    // if (content.isEmpty) return const Center(child: Text("No data found"));
    return StreamBuilder(
        stream: deps.firestore.getCollectionBasedListStream<YoutubeContentMd>(
          collection: FirestoreDep.ceremonyCn,
          fromJson: (p0) => YoutubeContentMd.fromJson(p0),
          toJson: (p0) => p0.toJson(),
          orderByKey: "is_uae",
          orderByValue: false,
        ),
        builder: (context, snapshot) {
          //if loading show loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final list = snapshot.data?.map((e) => e) ?? [];

            if (list.isEmpty) return const Center(child: Text("No data found"));

            return ListView(
              children: [
                for (final item in list)
                  DefaultListTile(
                    heroTag: item.id,
                    title: item.title,
                    subtitle: DateFormat.yMMMEd().format(item.uploadedAt!),
                    image: NetworkImage(
                        YoutubeThumbnail(youtubeId: item.link.youtubeLinkToId)
                            .standard()),
                    onTap: () {
                      onCardTap(item);
                    },
                  ),
              ],
            );
          } else {
            return const Center(child: Text('No data'));
          }
        });
  }

  void onCardTap(YoutubeContentMd item) {
    if (item.link.isEmpty) return;
    context
        .openWithHeroAnimation(YtPopup(item: item)); // Your popup screen widget
  }
}
