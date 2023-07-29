// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChurchScheduleView extends StatefulWidget {
  final String? collection;
  final String? documentId;
  const ChurchScheduleView({super.key, this.collection, this.documentId});

  @override
  State<ChurchScheduleView> createState() => _ChurchScheduleViewState();
}

class _ChurchScheduleViewState extends State<ChurchScheduleView> {
  final DependencyManager deps = DependencyManager();

  String? get collection => widget.collection;
  String? get documentId => widget.documentId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: deps.firestore.getCollectionBasedListStream<ContentMd>(
          collection: FirestoreDep.churchScheduleCn,
          fromJson: (p0) => ContentMd.fromJson(p0),
          toJson: (p0) => p0.toJson()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<ContentMd> list = snapshot.data as List<ContentMd>;

          if (list.isEmpty) return const Center(child: Text("No data found"));

          return ListView.separated(
            padding: const EdgeInsets.all(6),
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final model = list[index];
              return ExpansionTile(
                shape: const RoundedRectangleBorder(),
                title: Text(model.title),
                subtitle: Text(DateFormat.yMMMEd().format(model.uploadedAt)),
                children: [
                  for (int i = 0; i < model.content.length; i++)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 0,
                            title: model.content[i].title.isEmpty
                                ? null
                                : Text(model.content[i].title),
                            subtitle: DefaultQuillViewer(
                                text: model.content[i].description)),
                        if (i != model.content.length - 1)
                          const Divider(color: Colors.grey),
                      ],
                    ),
                ],
              );
            },
          );
        } else {
          return const Center(child: Text("No data found"));
        }
      },
    );
  }
}
