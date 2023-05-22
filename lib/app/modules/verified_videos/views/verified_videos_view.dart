// ignore_for_file: must_be_immutable, unused_local_variable
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets_images.dart';
import 'package:heyya/app/core/enum/media_state.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/heyya_exports.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/widget/custom_button.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/routes/app_pages.dart';
import '../../../core/assets/assets.dart';
import '../../../core/utils/inset_tool.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../core/widget/custom_scaffold.dart';
import '../../video/models/video_preview_model.dart';
import '../controllers/verified_videos_controller.dart';

//展示用户的所有Videos，
class VerifiedVideosView extends GetView<VerifiedVideosController> {
  const VerifiedVideosView({Key? key}) : super(key: key);

  Widget confirmWidget() {
    return Opacity(
      opacity: controller.isRecordEnable() ? 1 : 0,
      child: CustomButton(
          state: CustomButtonState.selected,
          titleForNormal: "Record",
          onTap: () {
            final preview =
                VideoPreviewModel(previewType: VideoPreviewType.add);
            Get.toNamed(Routes.VIDEO_GUIDING, arguments: preview);
          }),
    );
  }

  CustomAppBar? appBar() {
    return controller.isFromProfile
        ? null
        : CustomAppBar(
            backgroundColor: Colors.transparent,
            titleText: "My Videos",
            isBackButtonEnabled: true,
          );
  }

  Widget body() {
    return GetBuilder<VerifiedVideosController>(
      builder: (controller) => Stack(
        children: [
          Container(
            // height: Get.height - 200,
            color: Colors.transparent,
            padding: controller.isFromProfile
                ? EdgeInsets.zero
                : EdgeInsets.only(left: 16, right: 16),
            child: controller.videos.length > 0
                ? GridView.builder(
                    padding: controller.isFromProfile
                        ? EdgeInsets.only(top: 0)
                        : EdgeInsets.only(top: 0, bottom: 140),
                    physics: BouncingScrollPhysics(),
                    itemCount: controller.videos.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: (Get.width - 34) / 3,
                        childAspectRatio: 114 / 152,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1),
                    itemBuilder: ((context, index) {
                      return VerifiedVideoCell(media: controller.videos[index]);
                    }),
                  )
                : Container(),
          ),
          Positioned(
              bottom: 0, width: Get.width, height: 140, child: confirmWidget())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isFromProfile) {
      return body();
    } else {
      return CustomScaffoldWithBackground(
          appBar: CustomAppBar(
            backgroundColor: Colors.transparent,
            titleText: "My Videos",
            isBackButtonEnabled: true,
          ),
          body: SafeArea(
              child: Container(
            child: body(),
            width: Get.width,
            height: Get.height,
          )));
    }
  }
}

class VerifiedVideoCell extends StatelessWidget {
  MediaEntity media;
  VerifiedVideoCell({required this.media});

  Widget imageBackground() {
    final cover = media.cover;
    final avatar = Session.shard().user?.value.avatar;
    if (cover != null && cover.isNotEmpty) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ThemeColors.randomSparkTitleColor(),
            image: DecorationImage(
              image: ExtendedImage.network(
                cover,
              ).image,
              fit: BoxFit.cover,
            )),
      );
    } else if (avatar != null && avatar.isNotEmpty) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: ExtendedImage.network(
            avatar,
          ).image,
          fit: BoxFit.cover,
        )),
      );
    } else {
      return UnconstrainedBox(
        child: Center(
          child: const CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget inReview() {
    return Opacity(
      opacity: media.verifyState == MediaState.UNCHECKED ? 1 : 0,
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              alignment: Alignment.center,
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImages.verifyvideoMask,
                fit: BoxFit.cover,
              )),
              child: Text(
                "Reviewing",
                style: textStyle(fontSize: 10, color: Colors.white),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeColors.randomSparkTitleColor(),
          image: DecorationImage(
            image: ExtendedImage.network(
              media.cover ?? "",
            ).image,
            fit: BoxFit.cover,
          )),
      child: Stack(
        children: [
          Center(
              child: GestureDetector(
            onTap: () {
              Get.find<VerifiedVideosController>().toPreview(media);
            },
            child: Image.asset(
              Assets.verifyvideoPause,
            ),
          )),
          inReview(),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //opacity 0 隐藏
                Opacity(
                  opacity: (media.type == MediaType.MAIN_VIDEO ||
                          media.type == MediaType.VERIFY_VIDEO)
                      ? 1
                      : 0,
                  child: Image.asset(
                    media.type == MediaType.MAIN_VIDEO
                        ? Assets.verifyvideoMain
                        : Assets.videoVerified,
                  ),
                ),
                Expanded(child: Container()),
                Opacity(
                  opacity: media.type == MediaType.MAIN_VIDEO ? 0 : 1,
                  child: GestureDetector(
                    onTap: () {
                      if (media.type != MediaType.MAIN_VIDEO) {
                        Get.find<VerifiedVideosController>()
                            .showHeyyaMoreAction(media);
                      }
                    },
                    child: Image.asset(
                      Assets.verifyvideoMore,
                    ),
                  ),
                )
              ],
            ),
            left: 0,
            top: 0,
            right: 0,
          ),
        ],
      ),
    );
  }
}

bool isRouteExist(String route) {
  for (var element in Get.routeTree.routes) {
    if (element.name == route) {
      return true;
    }
  }
  return false;
}

bool isControllerExist<T>(String routes) {
  return existController<T>(routes) != null;
}

T? existController<T>(String routes) {
  try {
    for (var element in Get.routeTree.routes) {
      if (element.name == routes) {
        final vc = Get.find<T>();
        return vc;
      }
    }
  } on Exception catch (_) {
    return null;
  }

  return null;
}
