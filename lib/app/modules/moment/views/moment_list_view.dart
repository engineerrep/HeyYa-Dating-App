import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/utils/get_bottom_sheet.dart';
import 'package:heyya/app/core/widget/heyya_refresh_footer.dart';
import 'package:heyya/app/core/widget/heyya_refresh_header.dart';
import 'package:heyya/app/data/model/moment_entity.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/moment/controllers/moment_controller.dart';
import 'package:heyya/app/modules/moment/widgets/moment_list_item.dart';
import 'package:heyya/app/routes/app_pages.dart';

class MomentListView extends GetView<MomentController> {
  const MomentListView({Key? key}) : super(key: key);

  Future<void> _onRefresh() async {
    await controller.loadNext(true);
  }

  Future<void> _onLoad() async {
    await controller.loadNext(false);
  }

  _onMore(MomentEntity entity) {
    //todo：删除还是拉黑
    if (entity.userId == Session.getUser()?.id) {
      GetBottomSheet.showMomentDelete(momentId: entity.id);
    } else {
      GetBottomSheet.showHeyyaReprt(userId: entity.user.id ?? "");
    }
  }

  _onLike(MomentEntity entity) async {
    final controller = Get.find<MomentController>();
    if (entity.isThumb) {
      await controller.deleteThumbUp(entity.id);
    } else {
      await controller.thumbUp(entity.id, entity.userId);
    }
  }

  _onChat(MomentEntity entity) {
    controller.messageUser(entity);
  }

  _onPost() {
    Get.toNamed(Routes.MOMENT_POST);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          EasyRefresh(
            header: HeyyaRefreshHeader(),
            footer: controller.hasMore ? HeyyaRefreshFooter() : null,
            onRefresh: _onRefresh,
            onLoad: controller.hasMore ? _onLoad : null,
            child: ListView.builder(
              itemCount: controller.moments.length,
              itemBuilder: (context, index) {
                final entity = controller.moments[index];
                return MomentListItem(
                  entity: entity,
                  onMore: () => UserProfile.checkVideo(_onMore, [entity]),
                  onLike: () => UserProfile.checkVideo(_onLike, [entity]),
                  onChat: () => UserProfile.checkVideo(_onChat, [entity]),
                  onUserProfile: () {
                    Get.toNamed(Routes.USER_PROFILE,
                        arguments: entity.toUser());
                  },
                );
              },
            ),
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: GestureDetector(
              onTap: () => UserProfile.checkVideo(_onPost, null),
              child: ExtendedImage.asset(Assets.momentsPost),
            ),
          ),
        ],
      ),
    );
  }
}
