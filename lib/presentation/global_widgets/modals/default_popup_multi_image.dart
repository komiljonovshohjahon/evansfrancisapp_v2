import 'dart:convert';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/modals/images_carouse_popup.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultMultiImagePopup extends StatefulWidget {
  final String? title;
  final String? description;
  final bool decodeDescription;
  final List<ImageProvider?>? images;
  final String? heroTag;

  const DefaultMultiImagePopup(
      {super.key,
      this.title,
      this.description,
      this.heroTag,
      this.decodeDescription = false,
      this.images});

  @override
  State<DefaultMultiImagePopup> createState() => _DefaultMultiImagePopupState();
}

class _DefaultMultiImagePopupState extends State<DefaultMultiImagePopup> {
  DependencyManager deps = DependencyManager.instance;
  q.QuillController controller = q.QuillController.basic();

  String? get title => widget.title;

  String? get description => widget.description;

  bool get decodeDescription => widget.decodeDescription;
  List<ImageProvider?> images = [];

  final ScrollController _scrollController = ScrollController();

  bool hidePlaceholder = false;

  @override
  void initState() {
    if (decodeDescription && description != null) {
      try {
        var myJSON = jsonDecode(description!);
        controller = q.QuillController(
            document: q.Document.fromJson(myJSON),
            selection: const TextSelection.collapsed(offset: 0));
        // ignore: empty_catches
      } catch (e) {}
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final List<ImageProvider> list = [];
      await Future.delayed(const Duration(milliseconds: 700), () {
        hidePlaceholder = true;
        setState(() {});
      });
      for (final image in (widget.images ?? [])) {
        image!
            .resolve(const ImageConfiguration())
            .completer
            ?.addListener(ImageStreamListener((info, synchronousCall) {
              // Image loaded successfully

              logger('Image loaded successfully');
              list.add(image);
              images = list;
              setState(() {});
            }, onError: (exception, stackTrace) {
              // Error occurred while loading the image
              logger('Error loading image: $exception');
            }));
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.only(left: 36.w, right: 16.w),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.all(20.w),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      titleTextStyle: context.textTheme.titleMedium,
      title: Row(
        children: [
          if (title != null)
            SizedBox(
              width: context.width * 0.7,
              child: Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            )
          else
            const SizedBox.shrink(),
          const Spacer(),
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close))
        ],
      ),
      children: [
        Opacity(
          opacity: hidePlaceholder ? 0 : 1,
          child: Hero(
            tag: widget.heroTag ?? '',
            child: Image(
              image: widget.images?.firstOrNull ?? const AssetImage(''),
              width: context.width * 0.8,
              height: hidePlaceholder ? 0 : 200.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
        ),
        //image
        if (images.isNotEmpty)
          Scrollbar(
            controller: _scrollController,
            child: SizedBox(
              height: 200.h,
              width: context.width * 0.8,
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 8.h),
                controller: _scrollController,
                separatorBuilder: (context, index) => SizedBox(width: 20.w),
                itemCount: images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final list = images.reversed.toList() as List<ImageProvider>;
                  final image = list[index];
                  return Hero(
                    tag: index.toString(),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.r)),
                      onPressed: () {
                        context.openWithHeroAnimation(ImagesCarouselPopup(
                            initialPage: index,
                            images: list,
                            heroTag: index.toString()));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.r),
                        child: Image(
                          image: image,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        if (images.isNotEmpty) SizedBox(height: 20.h),
        //description
        if (decodeDescription && description != null)
          q.QuillEditor.basic(controller: controller, readOnly: true),
      ],
    );
  }
}
