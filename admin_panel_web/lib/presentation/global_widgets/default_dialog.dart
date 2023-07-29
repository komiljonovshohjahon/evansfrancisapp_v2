import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';

class DefaultDialog extends StatelessWidget {
  final WidgetBuilder builder;
  final String title;
  final bool isExpanded;
  final double? width;
  final double? height;
  DefaultDialog(
      {super.key,
      required this.builder,
      required this.title,
      this.width,
      this.height,
      this.isExpanded = true});

  final deps = DependencyManager.instance;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(16),
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      elevation: 10,
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: SpacedRow(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  horizontalSpace: 8,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: IconButton(
                        onPressed: () {
                          deps.navigation.router.pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Divider(color: Theme.of(context).dividerColor),
              if (isExpanded)
                Expanded(child: builder(context))
              else
                builder(context),
            ],
          ),
        ),
      ),
    );
  }
}
