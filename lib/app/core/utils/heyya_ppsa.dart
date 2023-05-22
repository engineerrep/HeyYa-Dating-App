import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/heyya_exports.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_constant.dart';
import 'package:heyya/app/core/widget/custom_button.dart';
import 'package:heyya/app/core/widget/heyya_webview.dart';
import 'package:heyya/app/data/local/Storage/storage.dart';
import 'package:heyya/app/routes/app_pages.dart';

class HeyyaPPSAWidget extends StatefulWidget {
  final String ppsaType;

  const HeyyaPPSAWidget({super.key, required this.ppsaType});

  @override
  State<HeyyaPPSAWidget> createState() => _HeyyaPPSAWidgetState();
}

class _HeyyaPPSAWidgetState extends State<HeyyaPPSAWidget> {
  final selectedArray = [false, false, false, false];
  final titlesArray = [
    'You solemnly swear that you are currently not married.',
    'You solemnly swear you currently do not have criminal record.',
    "If you lie about the above testimony, any app user or the app operator can sue you for at least \$1 million.",
    'By agreeing to the above and the agreement, you agree that the agreement is legally binding.',
  ];

  bool canSave = false;

  ppsaItemWidget(String title, int index) {
    final isSelected = selectedArray[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: CupertinoButton(
          pressedOpacity: 0.95,
          padding: EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(isSelected
                  ? Assets.reportChooseSelect
                  : Assets.reportChooseNormal),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  title,
                  style: textStyle(color: ThemeColors.c272b00, fontSize: 14),
                  maxLines: 10,
                ),
              )
            ],
          ),
          onPressed: () {
            setState(() {
              selectedArray[index] = !selectedArray[index];

              if (selectedArray
                      .firstWhereOrNull((element) => element == false) ==
                  null) {
                canSave = true;
              } else {
                canSave = false;
              }
            });
          }),
    );
  }

  Widget tipText(IntCallback callback) {
    return RichText(
      maxLines: 2,
      textAlign: TextAlign.left,
      text: TextSpan(children: [
        TextSpan(
            text: 'You can also check our ',
            style: textStyle(fontSize: 16, color: ThemeColors.c7f8a87)),
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

  Widget confirmWidget() {
    final state =
        canSave ? CustomButtonState.selected : CustomButtonState.disable;
    final button = CustomButton(
        state: state,
        titleForNormal: "I Accpet",
        onTap: () async {
          HeyStorage().setString(widget.ppsaType, '1');

          Get.back();
        });
    return SizedBox(height: 140, child: button);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container()),
        Container(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: Column(
            children: [
              Text(
                'You must check and agree to the following terms before you can use Heyya',
                style: textStyle(
                    color: ThemeColors.c1f2320,
                    fontSize: 16,
                    type: TextType.bold),
                maxLines: 2,
              ),
              Column(
                children: [0, 1, 2, 3].map<Widget>((e) {
                  return ppsaItemWidget(titlesArray[e], e);
                }).toList(),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: tipText((index) {
                      if (index == 0) {
                        Get.toNamed(Routes.PP_SA,
                            arguments: HeyyaWebviewType.sa);
                      } else {
                        Get.toNamed(Routes.PP_SA,
                            arguments: HeyyaWebviewType.pp);
                      }
                    }),
                  ),
                ),
              ),
              confirmWidget()
            ],
          ),
        )
      ],
    );
  }
}
