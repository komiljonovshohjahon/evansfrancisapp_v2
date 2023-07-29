import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/utils/global_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube/youtube_thumbnail.dart';

class YtPopup extends StatefulWidget {
  final YoutubeContentMd item;
  const YtPopup({super.key, required this.item});

  @override
  State<YtPopup> createState() => _YtPopupState();
}

class _YtPopupState extends State<YtPopup> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          isLoaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titleTextStyle: context.textTheme.titleMedium,
      contentPadding: EdgeInsets.all(16.w),
      titlePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      title: Row(
        children: [
          SizedBox(
              width: context.width * 0.8,
              child: Text(
                widget.item.title,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              )),
          const Spacer(),
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      children: [
        Hero(
          tag: widget.item.id,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36.r),
            child: SizedBox(
              height: 400.h,
              width: context.width * 0.8,
              child: !isLoaded
                  ? Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(YoutubeThumbnail(
                              youtubeId: widget.item.link.youtubeLinkToId)
                          .standard()),
                    )
                  : InAppWebView(
                      onWebViewCreated: (controller) {
                        controller.loadUrl(
                            urlRequest: URLRequest(
                          url: Uri.parse(
                              "https://www.youtube.com/embed/${widget.item.link.youtubeLinkToId}"),
                        ));
                      },
                      onEnterFullscreen: (controller) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight,
                        ]);
                      },
                      onExitFullscreen: (controller) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                      },
                    ),
            ),
          ),
        )
      ],
    );
  }
}
