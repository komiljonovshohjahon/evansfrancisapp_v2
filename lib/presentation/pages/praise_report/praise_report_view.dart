// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PraiseReportView extends StatefulWidget {
  final String? collection;
  final String? documentId;
  const PraiseReportView({super.key, this.collection, this.documentId});

  @override
  State<PraiseReportView> createState() => _PraiseReportViewState();
}

class _PraiseReportViewState extends State<PraiseReportView> {
  final DependencyManager deps = DependencyManager();

  String? get collection => widget.collection;
  String? get documentId => widget.documentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      context.futureLoading(() async {
        if (collection != null && documentId != null) {
          final item = await deps.firestore
              .findByCollectionAndDocumentId<PraiseReportMd>(
                  collection: collection!,
                  documentId: documentId!,
                  fromJson: (p0) => PraiseReportMd.fromJson(p0));
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
      stream: deps.firestore.getCollectionBasedListStream<PraiseReportMd>(
          collection: FirestoreDep.praiseReportCn,
          fromJson: (p0) => PraiseReportMd.fromJson(p0),
          toJson: (p0) => p0.toJson()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<PraiseReportMd> list =
              snapshot.data as List<PraiseReportMd>;

          if (list.isEmpty) return const Center(child: Text("No data found"));

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final model = list[index];
              return DefaultListTile(
                heroTag: model.id,
                title: model.title,
                subtitle: DateFormat.yMMMEd().format(model.uploadedAt!),
                image: DefaultCachedFirebaseImageProvider(
                    "${FirestoreDep.praiseReportCn}/${model.id}/0"),
                onTap: () {
                  onCardTap(model);
                },
              );
              // return ListTile(
              //   title: Text(model.title),
              //   subtitle: Text(DateFormat.yMMMEd().format(model.uploadedAt!)),
              //   onTap: () {
              //     showDialog(
              //         context: context,
              //         builder: (context) {
              //           return PraiseReportViewDialog(model: model);
              //         });
              //   },
              // );
            },
          );
        } else {
          return const Text('No data');
        }
      },
    );
  }

  void onCardTap(PraiseReportMd model) {
    context.openWithHeroAnimation(DefaultMultiImagePopup(
      title: model.title,
      images: [
        for (int i = 0; i < 10; i++)
          DefaultCachedFirebaseImageProvider(
              "${FirestoreDep.praiseReportCn}/${model.id}/$i")
      ],
      heroTag: model.id,
      decodeDescription: true,
      description: model.description,
    ));
  }
}
