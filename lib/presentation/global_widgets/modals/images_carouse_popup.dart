import 'package:carousel_slider/carousel_slider.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagesCarouselPopup extends StatefulWidget {
  final List<ImageProvider> images;
  final String heroTag;
  final int initialPage;
  const ImagesCarouselPopup(
      {super.key,
      required this.images,
      required this.heroTag,
      this.initialPage = 0});

  @override
  State<ImagesCarouselPopup> createState() => _ImagesCarouselPopupState();
}

class _ImagesCarouselPopupState extends State<ImagesCarouselPopup> {
  final CarouselController controller = CarouselController();

  List<ImageProvider> get images => widget.images;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(0),
      titlePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      title: Row(
        children: [
          SizedBox(
              width: context.width * 0.8,
              child: const Text(
                'Images',
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
        SizedBox(
          width: context.width,
          child: Hero(
            tag: widget.heroTag,
            child: CarouselSlider(
              carouselController: controller,
              options: CarouselOptions(
                enlargeCenterPage: true,
                height: context.height * 0.7,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                initialPage: widget.initialPage,
                autoPlay: false,
              ),
              items: images
                  .map((e) => Image(
                        image: e,
                        width: context.width,
                        fit: BoxFit.contain,
                      ))
                  .toList(),
            ),
          ),
        ),
        SpacedRow(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: controller.previousPage,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            IconButton(
              onPressed: controller.nextPage,
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        )
      ],
    );
  }
}
