import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/utils/get_bottom_alert.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/utils/heyya_ppsa.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/repository/report_block_repository.dart';
import 'package:heyya/app/modules/report/models/report_block_state.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';
import '../values/app_colors.dart';
import 'inset_tool.dart';

class GetBottomSheetAction {
  final String title;
  final Color titleColor;
  final GestureTapCallback? onTap;
  final bool onTapDismiss;
  final double fontSize;
  GetBottomSheetAction({required this.title, this.titleColor = ThemeColors.c1f2320, this.onTapDismiss = true, this.fontSize = 16, this.onTap});

  static GetBottomSheetAction cancelAction() {
    return GetBottomSheetAction(
        title: "Cancel",
        onTap: () {
          Get.back();
        });
  }

  /// 显示PPSA
  static showPPSAPopUps(BuildContext context, String ppsaType, {VoidCallback? callback}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => HeyyaPPSAWidget(
        ppsaType: ppsaType,
      ),
    );
  }
}

class GetBottomSheet {
  static final shared = GetBottomSheet();
  static final double pad = 16;

  static showMomentDelete({required String momentId}) {
    GetBottomSheet.showActions([
      GetBottomSheetAction(
          title: "Delete",
          titleColor: ThemeColors.cfe4281,
          onTap: () {
            Get.back();
            GetBottomAlert.showDeleteMomentAlert(doneCallback: () {
              Get.back();
            }, cancelCallback: () {
              Get.back();
              Get.find<ReportBlockState>().willDeleteMomentId = momentId;
              Action.confirmDeleteMoment();
            });
          }),
    ]);
  }

  static showHeyyaReprt({required String userId}) {
    GetBottomSheet.showActions([
      GetBottomSheetAction(
          title: "Block",
          titleColor: ThemeColors.cfe4281,
          onTap: () {
            Get.back();
            GetBottomAlert.showBlockAlert(doneCallback: () {
              Get.back();
            }, cancelCallback: () {
              Get.back();
              Get.find<ReportBlockState>().willBlockUserId = userId;
              Action.confirmBlock();
            });
          }),
      GetBottomSheetAction(
          title: "Report",
          onTap: () {
            Get.back();
            Get.find<ReportBlockState>().willReportUserId = userId;
            Get.toNamed(Routes.REPORT);
          })
    ]);
  }

  static showAction(GetBottomSheetAction action) {
    Get.bottomSheet(Container(
      margin: EdgeInsets.fromLTRB(pad, 0, pad, 33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          itemWidget(action: action),
          Insets.bottom(margin: 10),
          itemWidget(action: GetBottomSheetAction.cancelAction()),
        ],
      ),
    ));
  }

  static showActions(List<GetBottomSheetAction> actions) {
    List<Widget> temp = [];
    //final revertedActions = actions.reversed;
    for (var action in actions) {
      temp.add(itemWidget(action: action));
      temp.add(Divider(
        height: 0.1,
        color: ThemeColors.c272b00,
      ));
    }
    Get.bottomSheet(Container(
      margin: EdgeInsets.fromLTRB(pad, 0, pad, 33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end, //布局方式
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: temp,
            ),
          ),
          Insets.bottom(margin: 10),
          itemWidget(action: GetBottomSheetAction.cancelAction()),
        ],
      ),
    ));
  }

  static Widget itemWidget({required GetBottomSheetAction action, double circular = 8}) {
    return defaultChild(defaultContainer(child: Text(action.title, style: textStyle(type: TextType.regular, color: action.titleColor, fontSize: action.fontSize))), action.onTap);
  }

  static Widget defaultChild(Widget child, GestureTapCallback? onTap) {
    return GestureDetector(child: child, onTap: onTap);
  }

  static Widget defaultContainer({required Widget child, double circular = 8}) {
    return Container(
      width: Get.width - pad * 2,
      height: 54,
      alignment: Alignment.center,
      child: child,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(circular)),
    );
  }
}

extension Action on GetBottomSheet {
  static Future<bool> performBlock() async {
    try {
      final reportRepository = ReportBlockRepository();
      var toUserId = Get.find<ReportBlockState>().willBlockUserId;
      if (toUserId != null) {
        await reportRepository.blockUser(toUserId);
        Get.find<ReportBlockState>().didFinishBlock();
        return true;
      } else {
        HeySnackBar.showError("ReportBlockState user is null");
        return false;
      }
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
      return false;
    }
  }

  static void confirmBlock() async {
    final cancelLoading = showLoading();
    final success = await performBlock();
    cancelLoading();
    if (success) {
      HeySnackBar.showSuccess("Success");
    }
  }

  static void confirmDeleteMoment() async {
    final cancelLoading = showLoading();
    final success = await performDeleteMoment();
    cancelLoading();
    if (success) {
      HeySnackBar.showSuccess("Success");
    }
  }

  static Future<bool> performDeleteMoment() async {
    try {
      final reportRepository = ReportBlockRepository();
      var momentId = Get.find<ReportBlockState>().willDeleteMomentId;
      if (momentId != null) {
        await reportRepository.deleteMoment(momentId);
        Get.find<ReportBlockState>().didDeleleMoment();
        return true;
      } else {
        HeySnackBar.showError("ReportBlockState user is null");
        return false;
      }
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
      return false;
    }
  }
}
