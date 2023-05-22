import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/widget/heyya_refresh_footer.dart';
import 'package:heyya/app/core/widget/heyya_refresh_header.dart';

extension RelationList on HeyyaListView {
  static HeyyaListView listView({
    required OnRefreshCallback onRefresh,
    required OnLoadCallback onLoad,
    required bool hasNextPage,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return HeyyaListView(
        onRefresh: onRefresh,
        onLoad: onLoad,
        hasNextPage: hasNextPage,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        maxCrossAxisExtent: (Get.width - 34) / 2,
        childAspectRatio: 165 / 280,
        mainAxisSpacing: 13,
        crossAxisSpacing: 12);
  }
}

// ignore: must_be_immutable
class HeyyaListView extends StatelessWidget {
  OnRefreshCallback onRefresh;
  OnLoadCallback onLoad;
  bool hasNextPage;
  int itemCount;
  IndexedWidgetBuilder itemBuilder;
  double maxCrossAxisExtent;
  double childAspectRatio;
  double mainAxisSpacing;
  double crossAxisSpacing;
  HeyyaListView({
    super.key,
    required this.onRefresh,
    required this.onLoad,
    required this.itemCount,
    required this.itemBuilder,
    this.hasNextPage = false,
    this.maxCrossAxisExtent = 0,
    this.childAspectRatio = 0,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: Insets.insetsWith(type: InsetsType.leftRight),
      child: EasyRefresh(
        header: HeyyaRefreshHeader(),
        footer: hasNextPage ? HeyyaRefreshFooter() : null,
        onRefresh: onRefresh,
        onLoad: hasNextPage ? onLoad : null,
        child: GridView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: itemCount,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxCrossAxisExtent,
                childAspectRatio: childAspectRatio,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing),
            itemBuilder: itemBuilder),
      ),
    ));
  }
}
