import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/utils/get_route_helper.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/core/widget/placeholder_view.dart';
import 'package:heyya/app/data/repository/heyya_list_repostitory.dart';
import 'package:heyya/app/modules/profile/controllers/my_likes_controller.dart';
import 'package:heyya/app/modules/profile/list/heyya_list_cell.dart';
import 'package:heyya/app/modules/profile/list/heyya_list_view.dart';

class MyLikesView extends GetView<MyLikesController> {
  const MyLikesView({Key? key}) : super(key: key);

  Future<void> _onRefresh() async {
    await controller.getUserPageInfos(
        type: ApiType.mylikeList, isRefresh: true);
  }

  Future<void> _onLoad() async {
    await controller.getUserPageInfos(
        type: ApiType.mylikeList, isRefresh: false);
  }

  Widget listViewWidget() {
    return RelationList.listView(
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        hasNextPage: controller.hasNextpage(),
        itemCount: controller.pageCount(),
        itemBuilder: ((context, index) {
          return HeyyaListCell(relation: controller.object(index));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: CustomAppBar(
        titleText: "My Likes",
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
        isBackButtonEnabled: true,
      ),
      body: controller.obx((_) => listViewWidget(),
          onLoading: const HeyyaLoadingIndicator(),
          onEmpty: PlaceholderView.mylikesPlaceholder(
            callback: () => GetRouteHelper.backToSpark(),
          ), onError: (_) {
        return PlaceholderView.serverErrorPlaceholder();
      }),
    );
  }
}
