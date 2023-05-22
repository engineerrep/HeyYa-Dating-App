import 'package:align_positioned/align_positioned.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/utils/get_bottom_sheet.dart';
import 'package:heyya/app/data/model/spark_entity.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/spark/controllers/spark_controller.dart';
import 'package:heyya/app/modules/spark/widgets/spark_card.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SparkCardStack extends GetView<SparkController> {
  _onMore({required String userId}) {
    GetBottomSheet.showHeyyaReprt(userId: userId);
  }

  _checkProfile(Function()? fn) {
    if (UserProfile.completeVideoIfNeeded(true)) {
      return;
    }
    fn?.call();
  }

  _onMessage() {
    controller.messageUser();
  }

  _onLike() {
    controller.swipableStackController
        .next(swipeDirection: SwipeDirection.right);
  }

  _onUnlike() {
    controller.swipableStackController
        .next(swipeDirection: SwipeDirection.left);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 13.0,
            child: ExtendedImage.asset(
              Assets.sparkShadow,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SwipableStack(
                      stackClipBehaviour: Clip.none,
                      allowVerticalSwipe: false,
                      itemCount: controller.sparks.length,
                      controller: controller.swipableStackController,
                      builder: (context, property) {
                        return SparkCard(
                          entity: controller.sparks[property.index],
                          onAvatar: () {
                            final entity = controller.sparks[property.index];
                            Get.toNamed(Routes.USER_PROFILE,
                                arguments: entity.toUser());
                          },
                          onMore: () {
                            _onMore(
                                userId: controller.sparks[property.index].id);
                          },
                          autoPlay: property.stackIndex == 0 &&
                              property.swipeProgress == 0.0,
                          isSwipedComplete: property.stackIndex < 0,
                        );
                      },
                      onWillMoveNext: (index, swipeDirection) {
                        if (UserProfile.completeVideoIfNeeded(true)) {
                          return false;
                        }
                        if (index == controller.sparks.length - 5) {
                          controller.loadNext(false);
                        }
                        return true;
                      },
                      onSwipeCompleted: (index, direction) {
                        final entity = controller.sparks[index];
                        if (direction == SwipeDirection.left) {
                          controller.unlike(entity.id);
                        } else if (direction == SwipeDirection.right) {
                          controller.like(entity.id);
                        }
                        if (index == controller.sparks.length - 1) {
                          controller.emitEmpty();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                // ExtendedImage.asset(Assets.sparkSlide, fit: BoxFit.cover),
                const SizedBox(height: 13.0),
              ],
            ),
          ),
          AlignPositioned.expand(
            alignment: Alignment.bottomLeft,
            dx: 60.0,
            dy: -50.0,
            child: GestureDetector(
              onTap: () => _onUnlike(),
              child: ExtendedImage.asset(Assets.sparkPass),
            ),
          ),
          AlignPositioned.expand(
            alignment: Alignment.bottomCenter,
            dy: -65.0,
            child: GestureDetector(
              onTap: () => UserProfile.checkVideo(_onMessage, null),
              child: ExtendedImage.asset(Assets.sparkMessage),
            ),
          ),
          AlignPositioned.expand(
            alignment: Alignment.bottomRight,
            dx: -60.0,
            dy: -50.0,
            child: GestureDetector(
              onTap: () => UserProfile.checkVideo(_onLike, null),
              child: ExtendedImage.asset(Assets.sparkLike),
            ),
          ),
        ],
      ),
    );
  }
}
