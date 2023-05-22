import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/heyya_exports.dart';
import 'package:heyya/app/core/utils/custom_page_view.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/data/model/short_video_entity.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/video_list/views/video_player.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../controllers/video_list_controller.dart';

const horizontalPadding = 20.0;

class VideoListView extends GetView<VideoListController> {
  const VideoListView({Key? key}) : super(key: key);

  Widget videoWidget(ShortVideoEntity entity, int index) {
    Widget? playWidget;

    if (controller.videoWidgets.length <= index) {
      controller.videoWidgets.add(VideoPlayerWidget(
        shortVideoEntity: entity,
        index: index,
        gkey: GlobalKey(debugLabel: 'origin_$index'),
        autoLoadVideo: index == 0,
      ));
      playWidget = controller.videoWidgets.last;
    } else {
      playWidget = controller.videoWidgets[index];
    }

    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: playWidget,
    );
  }

  Widget descWidget(ShortVideoEntity shortVideoEntity) {
    String videoDesc = shortVideoEntity.video?.content ?? '';
    if (videoDesc.isEmpty) {
      videoDesc = shortVideoEntity.user?.aboutMe ?? '';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: horizontalPadding,
              bottom: horizontalPadding + 10,
              right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 头像、昵称
                  CupertinoButton(
                    pressedOpacity: 0.95,
                    padding: EdgeInsets.zero,
                    onPressed: () => Get.toNamed(Routes.USER_PROFILE,
                        arguments: shortVideoEntity.user),
                    child: Row(
                      children: [
                        GFAvatar(
                          size: 36 / 1.5,
                          backgroundColor: ThemeColors.cddef00,
                          backgroundImage: ExtendedImage.network(
                            shortVideoEntity.user?.avatar ?? '',
                            fit: BoxFit.cover,
                          ).image,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            shortVideoEntity.user?.nickname ?? '',
                            style: textStyle(
                                color: Colors.white,
                                fontSize: 16,
                                type: TextType.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  // 视频描述
                  SizedBox(
                    width: Get.width - horizontalPadding * 2 - 68,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        videoDesc,
                        maxLines: 99,
                        style: textStyle(
                            color: Colors.white,
                            fontSize: 14,
                            type: TextType.regular),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(child: Container()),
              // 工具按钮
              shortVideoEntity.user?.id == Session.getUser()?.id
                  ? Container()
                  : SizedBox(
                      height: 68 *
                          (shortVideoEntity.video?.type == MediaType.VIDEO
                              ? 3
                              : 2),
                      width: 68,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              pressedOpacity: 0.95,
                              child: Image.asset(
                                  shortVideoEntity.user?.liked ?? false
                                      ? Assets.sparkLiked
                                      : Assets.sparkLike),
                              onPressed: () {
                                UserProfile.checkVideo(
                                    controller.like, [shortVideoEntity]);
                              },
                            ),
                          ),
                          Expanded(
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              pressedOpacity: 0.95,
                              child: Image.asset(Assets.sparkMessage),
                              onPressed: () {
                                UserProfile.checkVideo(
                                    controller.onMessage, [shortVideoEntity]);
                              },
                            ),
                          ),
                          shortVideoEntity.video?.type == MediaType.VIDEO
                              ? Expanded(
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    pressedOpacity: 0.95,
                                    child: Image.asset(Assets.videoForward),
                                    onPressed: () async {
                                      UserProfile.checkVideo(
                                          controller.onForward,
                                          [shortVideoEntity]);
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }

  Widget addWidget() => Positioned(
      top: 50,
      right: 20,
      child: CupertinoButton(
          padding: EdgeInsets.zero,
          pressedOpacity: 0.95,
          child: Image.asset(Assets.videoAdd),
          onPressed: () {
            UserProfile.checkVideo(controller.addVideo, null);
          }));

  Widget moreWidget() => Positioned(
      top: 50,
      left: 20,
      child: CupertinoButton(
          padding: EdgeInsets.zero,
          pressedOpacity: 0.95,
          child: Image.asset(Assets.videoMore),
          onPressed: () {
            controller.onMore();
          }));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: VisibilityDetector(
        key: GlobalKey(debugLabel: 'VideoPlayView'),
        onVisibilityChanged: (info) {
          try {
            print('${info.key.toString()} ${info.size}');
            controller.pauseVideo();
          } on Exception catch (e) {
            print(e);
          }
        },
        child: Container(
          color: Colors.black,
          child: GetBuilder<VideoListController>(
              builder: (controller) => Stack(
                    children: [
                      (controller.pageInfoEntity?.list.length ?? 0) != 0
                          ? SizedBox(
                              width: Get.width,
                              height: Get.height -
                                  MediaQuery.of(context).padding.bottom,
                              child: CustomPageView.builder(
                                  physics: const PageScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  controller: controller.pageController,
                                  onPageChanged: (value) {},
                                  onPageEndChanged: (value) {
                                    int previousIndex = value - 1;
                                    int nextIndex = value + 1;

                                    controller.stopVideo(previousIndex);
                                    controller.stopVideo(nextIndex);

                                    controller.playVideo(value);
                                  },
                                  onPageStartChanged: (value) {},
                                  itemBuilder: (context, index) {
                                    ShortVideoEntity shortVideoEntity =
                                        controller
                                                .pageInfoEntity?.list[index] ??
                                            ShortVideoEntity();

                                    return SizedBox(
                                      width: double.infinity,
                                      height: Get.height -
                                          MediaQuery.of(context).padding.bottom,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          videoWidget(shortVideoEntity, index),
                                          descWidget(shortVideoEntity)
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount:
                                      controller.pageInfoEntity?.list.length ??
                                          0),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                      addWidget(),
                      moreWidget()
                    ],
                  )),
        ),
      ),
    );
  }
}
