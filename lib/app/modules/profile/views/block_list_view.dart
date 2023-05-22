import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/core/widget/heyya_refresh_footer.dart';
import 'package:heyya/app/core/widget/heyya_refresh_header.dart';
import 'package:heyya/app/core/widget/placeholder_view.dart';
import 'package:heyya/app/data/model/relation_user_entity.dart';
import 'package:heyya/app/data/repository/heyya_list_repostitory.dart';
import 'package:heyya/app/data/repository/report_block_repository.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:heyya/app/routes/app_pages.dart';
import '../controllers/block_list_controller.dart';

class BlockListView extends GetView<BlockListController> {
  const BlockListView({Key? key}) : super(key: key);

  Future<void> _onRefresh() async {
    await controller.getUserPageInfos(type: ApiType.blockList, isRefresh: true);
  }

  Future<void> _onLoad() async {
    await controller.getUserPageInfos(
        type: ApiType.blockList, isRefresh: false);
  }

  Widget listViewWidget() {
    return SafeArea(
        child: Container(
      padding: Insets.insetsWith(type: InsetsType.leftRight),
      child: EasyRefresh(
        header: HeyyaRefreshHeader(),
        footer: HeyyaRefreshFooter(),
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        child: ListView.builder(
          itemCount: controller.pageCount(),
          itemBuilder: (context, index) {
            return BlockListItemView(relation: controller.object(index));
          },
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: CustomAppBar(
        titleText: "Blocked List",
        isBackButtonEnabled: true,
      ),
      body: controller.obx((_) => listViewWidget(),
          onLoading: const HeyyaLoadingIndicator(),
          onEmpty: PlaceholderView.blocklistPlaceholder(),
          onError: (_) => PlaceholderView.serverErrorPlaceholder()),
    );
  }
}

class BlockListItemView extends StatelessWidget {
  RelationUserEntity relation;
  BlockListItemView({super.key, required this.relation});

  Widget avatarWidget() {
    final avatar = relation.toUser.avatar;
    if (avatar != null && avatar.isNotEmpty) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: ExtendedImage.network(
                avatar,
              ).image,
              fit: BoxFit.cover,
            )),
      );
    } else {
      return ExtendedImage(image: AssetImages.imageBgAvatar);
    }
  }

  Future<bool> performUnblock() async {
    try {
      final blockRepository = ReportBlockRepository();
      final uid = relation.toUser.id;
      if (uid != null) {
        await blockRepository.unblockUser(uid);
        Get.find<BlockListController>().removeUser(userId: uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }

  void unblock() async {
    final cancelLoading = showLoading();
    final success = await performUnblock();
    cancelLoading();
    if (success) {
      if (Get.isSnackbarOpen) {
        Get.back();
      }
      HeySnackBar.showSuccess("Success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: Row(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 50,
                height: 50,
                child: avatarWidget(),
              ),
            ),
            Insets.right(margin: 10),
            Expanded(
              child: Text(relation.toUser.nickname ?? "null",
                  style: textStyle(
                      fontSize: 20,
                      color: ThemeColors.c1f2320,
                      type: TextType.bold)),
            ),
            GestureDetector(
              child: Container(
                width: 64,
                height: 24,
                child: Center(
                  child: Text(
                    "Remove",
                    style: textStyle(
                        type: TextType.regular,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4)),
              ),
              onTap: () {
                unblock();
              },
            ),
          ],
        ));
  }
}
