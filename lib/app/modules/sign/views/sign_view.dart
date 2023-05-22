// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/enum/device.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_constant.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/heyya_webview.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/modules/sign/controllers/sign_controller.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:video_player/video_player.dart';

class SignView extends GetView<SignController> {
  const SignView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: ClipRect(
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(),
                child: Obx(
                  () => Center(
                    child: controller.playerInitialized.value
                        ? AspectRatio(
                            aspectRatio: controller.player.value.aspectRatio,
                            child: VideoPlayer(controller.player),
                          )
                        : Container(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: Get.height * 0.1453,
            child: centerContainer(),
          ),
          Positioned(
              child: Container(
                width: Get.width,
                height: Get.height * 0.1453,
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: tipText((index) {
                      if (index == 0) {
                        controller.logger.i('Terms');
                        Get.toNamed(Routes.PP_SA,
                            arguments: HeyyaWebviewType.sa);
                      } else {
                        controller.logger.i('Policy');
                        Get.toNamed(Routes.PP_SA,
                            arguments: HeyyaWebviewType.pp);
                      }
                    }),
                  ),
                ),
              ),
              bottom: 0),
        ],
      ),
    );
  }

  Widget signPlatform() {
    if (GetPlatform.isAndroid) {
      return GestureDetector(
        onTap: () {
          controller.googleSignIn();
        },
        child: Container(
            decoration: BoxDecoration(
              color: ThemeColors.cddef00,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 50),
            height: 50,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.trademarkGoogle),
                SizedBox(width: 10),
                Text(controller.signInwithPlatform(),
                    style: textStyle(fontSize: 16, color: ThemeColors.c1f2320))
              ],
            )),
      );
    } else {
      return GestureDetector(
        onTap: () {
          controller.appleSignIn();
        },
        child: Container(
            decoration: BoxDecoration(
              color: ThemeColors.cddef00,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 50),
            height: 50,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.trademarkGoogle),
                SizedBox(width: 10),
                Text(controller.signInwithPlatform(),
                    style: textStyle(fontSize: 16, color: ThemeColors.c1f2320))
              ],
            )),
      );
    }
  }

  Container centerContainer() {
    return Container(
        decoration: BoxDecoration(
            // color: Colors.yellow,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/signin/log_In_mask.png'))),
        height: 465,
        width: Get.width,
        child: Column(
          children: [
            Spacer(),
            Image.asset('assets/images/signin/sign_in_logo.png',
                width: 74, height: 74),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  // GetPlatform.isIOS
                  //     ? "Make New Friends & Share Videos"
                  //     :
                  "Make a selfie video to join the world's most authentic dating app!",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: textStyle(
                      type: TextType.bold,
                      fontSize: 17,
                      color: ThemeColors.c1f2320)),
            ),
            SizedBox(height: 40),
            Column(
              children: [
                signPlatform(),
                Insets.top(margin: 15),
                GestureDetector(
                  onTap: () {
                    controller.deviceSignIn();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: new Border.all(color: Colors.black, width: 1),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      width: Get.width - 100,
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Assets.signInDevice),
                          SizedBox(width: 10),
                          Text(controller.signInwithDevice(),
                              style: textStyle(
                                fontSize: 16,
                                color: ThemeColors.c1f2320,
                              ))
                        ],
                      )),
                )
              ],
            ),
          ],
        ));
  }

  Widget tipText(IntCallback callback) {
    return RichText(
      maxLines: 2,
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
            text: 'By clicking sign in, you agree to our',
            style: textStyle(fontSize: 16, color: ThemeColors.c7f8a87)),
        TextSpan(text: '\n'),
        TextSpan(
            text: HeyyaWebviewType.sa.toText(),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                callback(0);
              },
            style: textStyle(
                fontSize: 16,
                color: ThemeColors.c1f2320,
                decoration: TextDecoration.underline)),
        TextSpan(
            text: ' and ',
            style: textStyle(fontSize: 16, color: ThemeColors.c7f8a87)),
        TextSpan(
            text: HeyyaWebviewType.pp.toText(),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                callback(1);
              },
            style: textStyle(
                fontSize: 16,
                color: ThemeColors.c1f2320,
                decoration: TextDecoration.underline)),
      ]),
    );
  }
}
