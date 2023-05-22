import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/core/widget/heyya_container.dart';
import 'package:heyya/app/modules/video/controllers/video_guiding_controller.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../component/video_tip_view.dart';

class VideoGuidingView extends GetView<VideoGuidingController> {
  const VideoGuidingView({Key? key}) : super(key: key);

  Widget leading() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Image.asset(Assets.signCancelAll),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
          titleText: "",
          leading: leading(),
          isBackButtonEnabled: true,
        ),
        body: body(context));
  }

  Widget camera() {
    var height = Get.height - (Get.height > 668 ? 320 : 272) - 120;

    return HeyContainer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset(Assets.imagePeople, fit: BoxFit.fitHeight),
          ),
          Positioned(
            top: -18,
            right: 10,
            child: Image.asset(Assets.imageQipao),
          )
        ],
      ),
      height: height,
      width: height / 380 * 284,
    );
  }

  Widget body(BuildContext context) {
    List<Permission> permissions = [
      Permission.microphone,
      Permission.camera,
    ];
    if (GetPlatform.isAndroid) {
      permissions.add(Permission.speech);
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(top: 30, left: 0, right: 0, child: camera()),
        Positioned(
          bottom: 0,
          child: Container(
            // color: Colors.red,
            height: Get.height > 668 ? 320 : 272,
            width: Get.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(Assets.loginVideoWhiteboard))),
            child: VideoTipView(),
          ),
        ),
        Positioned(
            bottom: Get.height > 668 ? 281 : 233,
            child: GestureDetector(
              onTap: () {
                AppManager.shared
                    .checkPermission(permissions,
                        tipContent:
                            'Heyya needs access to your camera/microphone. So you can take video to complete your profile.')
                    .then((value) {
                  if (value) {
                    controller.toSignin();
                  }
                });
              },
              child: Image.asset(Assets.logInVideoStart),
            )),
      ],
    );
  }
}
