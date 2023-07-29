import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/manager/manager.dart';
import 'package:evansfrancisapp/presentation/pages/home/widgets/home_card_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final List<Map<String, dynamic>> homeMenus = [
  {
    "route": MCANavigation.ministryDilkumar,
    "title": "Ministry of Pastor Dilkumar",
    "image": 'assets/menu_images/menu_1.jpg',
  },
  {
    "route": MCANavigation.uaeYt,
    "title": "UAE KRCI",
    "image": 'assets/menu_images/menu_2.jpg',
  },
  {
    "route": MCANavigation.dailyDevotion,
    "title": "Daily Devotional",
    "image": 'assets/menu_images/menu_3.jpg',
  },
  {
    "route": MCANavigation.scripture,
    "title": "Scripture of the Day",
    "image": 'assets/menu_images/menu_4.jpg',
  },
  {
    "route": MCANavigation.praiseReport,
    "title": "Praise Report",
    "image": 'assets/menu_images/menu_5.jpg',
  },
  {
    "route": MCANavigation.churchSchedule,
    "title": "Church Schedule",
    "image": 'assets/menu_images/menu_6.jpg',
  },
  {
    "route": MCANavigation.prayerRequest,
    "title": "Submit a Prayer Request",
    "image": 'assets/menu_images/menu_7.jpg',
  },
  {
    "route": MCANavigation.submitPraiseReport,
    "title": "Submit a Praise Report",
    "image": 'assets/menu_images/menu_8.jpg',
  },
  {
    "route": MCANavigation.submitSpecialRequest,
    "title": "Special Requests",
    "image": 'assets/menu_images/menu_9.jpg',
  },
  {
    "route": MCANavigation.contactChurchOffice,
    "title": "Contact Church Office",
    "image": 'assets/menu_images/menu_10.jpg',
  },
  {
    "route": MCANavigation.socialMedia,
    "title": "Follow Us",
    "image": 'assets/menu_images/menu_11.jpg',
  },
];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _DebugViewState();
}

class _DebugViewState extends State<HomeView> {
  final CarouselController carouselController = CarouselController();
  final List<String> banners = List.empty(growable: true);
  int _currentBannerIndex = 0;

  @override
  void initState() {
    DependencyManager.instance.fireStorage
        .getReference("banners")
        .listAll()
        .then((value) {
      for (var element in value.items) {
        element.getDownloadURL().then((value) {
          setState(() {
            banners.add(value);
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // if (kDebugMode)
        // ElevatedButton(
        //     onPressed: () {
        //       NotificationService().showNotification(
        //           title: "Hello world",
        //           body: "Shoh",
        //           payload: jsonEncode({
        //             "route": "dailyDevotion",
        //             "documentId": "TiY5aPo81BJAj2LQFWNE",
        //             "collection": "devotion"
        //           }));
        //     },
        //     child: const Text('Show Notification')),
        // ElevatedButton(
        //     onPressed: () {
        //       NotificationService().scheduleNotification(
        //         seconds: 5,
        //         title: "Hello world",
        //         body: "Shoh",
        //       );
        //     },
        //     child: const Text('Show Notification')),
        if (banners.isNotEmpty)
          Stack(
            children: [
              CarouselSlider(
                carouselController: carouselController,
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentBannerIndex = index;
                    });
                  },
                  autoPlay: !kDebugMode,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  autoPlayAnimationDuration: const Duration(milliseconds: 250),
                  autoPlayInterval: const Duration(seconds: 5),
                ),
                items: banners.map((imgUrl) {
                  return Image.network(imgUrl,
                      // placeholder: (context, url) => const SizedBox(
                      //       child: Center(
                      //         child: CircularProgressIndicator(),
                      //       ),
                      //     ),
                      errorBuilder: (context, url, error) {
                    logger(error.toString());
                    return const SizedBox(
                      child: Center(
                        child: Icon(Icons.error),
                      ),
                    );
                  });
                }).toList(),
              ),
              Positioned(
                  bottom: 0,
                  left: context.width / 2 - (30.w * banners.length) / 2,
                  child:
                      //build a widget to display the indicator
                      Container(
                    width: (30.w * banners.length),
                    height: 36.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: banners.map((url) {
                        int index = banners.indexOf(url);
                        return Container(
                          width: 14.w,
                          height: 14.h,
                          margin: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 6.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentBannerIndex == index
                                ? context.colorScheme.secondary
                                : Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  )),

              // //Move to next button on right center
              // Align(
              //   heightFactor: 4,
              //   alignment: Alignment.centerRight,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         shape: const CircleBorder(),
              //         padding: const EdgeInsets.all(8)),
              //     onPressed: carouselController.nextPage,
              //     child: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              //   ),
              // ),
              //
              // //Move to previous button on left center
              // Align(
              //   heightFactor: 4,
              //   alignment: Alignment.centerLeft,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         shape: const CircleBorder(),
              //         padding: const EdgeInsets.all(8)),
              //     onPressed: carouselController.previousPage,
              //     child: const Icon(Icons.arrow_back_ios_rounded, size: 16),
              //   ),
              // ),
            ],
          ),

        // HomeCardWidget(headerFontSize: 48, title: "KRCI 2023")),
        for (final menu in homeMenus)
          HomeCardWidget(
            route: menu["route"],
            title: menu["title"],
            image: menu["image"],
          ),
      ],
    );
  }
}
