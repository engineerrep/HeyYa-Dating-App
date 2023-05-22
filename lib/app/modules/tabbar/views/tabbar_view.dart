// ignore_for_file: must_be_immutable

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/modules/conversation/views/conversation_view.dart';
import 'package:heyya/app/modules/moment/views/moment_view.dart';
import 'package:heyya/app/modules/profile/controllers/profile_controller.dart';
import 'package:heyya/app/modules/profile/views/profile_view.dart';
import 'package:heyya/app/modules/spark/views/spark_view.dart';
import 'package:heyya/app/modules/video_list/views/video_list_view.dart';

import '../controllers/tabbar_controller.dart';

class TabbarView extends GetView<TabbarController> {
  TabbarView({Key? key}) : super(key: key);

  final List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
        icon: Center(child: ExtendedImage.asset(Assets.tabVideoNormal)),
        activeIcon: Center(child: ExtendedImage.asset(Assets.tabVideoSelect))),
    BottomNavigationBarItem(
        icon: Center(child: ExtendedImage.asset(Assets.tabSparkNormal)),
        activeIcon: Center(child: ExtendedImage.asset(Assets.tabSparkSelect))),
    BottomNavigationBarItem(
        icon: Center(child: ExtendedImage.asset(Assets.tabMomentNormal)),
        activeIcon: Center(child: ExtendedImage.asset(Assets.tabMomentSelect))),
    BottomNavigationBarItem(
        icon: Center(child: ExtendedImage.asset(Assets.tabMessageNormal)),
        activeIcon:
            Center(child: ExtendedImage.asset(Assets.tabMessageSelect))),
    BottomNavigationBarItem(
        icon: Center(child: ExtendedImage.asset(Assets.tabProfileNormal)),
        activeIcon:
            Center(child: ExtendedImage.asset(Assets.tabProfileSelect))),
  ];

  final List<Widget> bodyWidgets = [
    VideoListView(),
    SparkView(),
    MomentView(),
    ConversationView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            items: bottomItems,
            onTap: (index) {
              if (index == bottomItems.length - 1) {
                final controller = Get.find<ProfileController>();
                controller.getRelation();
              }
            }),
        controller: controller.cupertinoTabContoller.value,
        tabBuilder: (context, index) {
          return bodyWidgets[index];
        });
  }
}
