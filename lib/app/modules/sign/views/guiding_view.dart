import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/heyya_container.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

class GuidingView extends StatefulWidget {
  const GuidingView({Key? key}) : super(key: key);

  @override
  State<GuidingView> createState() => _GuidingViewState();
}

class _GuidingViewState extends State<GuidingView>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  var step = 0;
  bool buttonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)..addListener(() {});
  }

  doneClick() {
    // Get.offAllNamed(Routes.VIDEO_GUIDING,
    //     arguments: VideoPreviewModel(previewType: VideoPreviewType.sign));
    //完善Profile
    UserProfile.completeProfileIfNeeded(needed: true, showAlert: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            bottom: (Get.width / Get.height < 376.0 / 667.0) ? 0 : null,
            child: Lottie.asset(
                // GetPlatform.isIOS
                //     ? "assets/lottie/sign_guide_ios.json"
                //     :
                'assets/lottie/sign_guide.json',
                width: Get.width,
                height: (Get.width / Get.height < 376.0 / 667.0)
                    ? (Get.width / 414 * 812)
                    : null,
                fit: BoxFit.cover,
                controller: _controller, onLoaded: ((comp) {
              print(comp);
              // 136 424 750
              //tital: 758
              _controller
                ..duration = Duration(
                    milliseconds: (comp.seconds * 1000).toInt()); // 17秒
              var duration = 126.0 / 743.0;
              _controller
                  .animateTo(duration)
                  .whenCompleteOrCancel(() => buttonEnabled = true);
              step = 1;
            })),
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                if (!buttonEnabled) {
                  return;
                }
                double duration = 0;
                if (step == 0) {
                  duration = 126.0 / 743.0;
                  step = 1;
                } else if (step == 1) {
                  duration = 416.0 / 743.0;
                  step = 2;
                } else if (step == 2) {
                  duration = 735.0 / 743.0;
                  step = 3;
                } else {
                  doneClick();
                  return;
                }
                buttonEnabled = false;
                _controller
                    .animateTo(duration)
                    .whenCompleteOrCancel(() => buttonEnabled = true);
              },
              child: Container(
                color: Colors.transparent,
                height: 200,
                width: Get.width,
                // color: Colors.red,

                // child: Text(' '),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
