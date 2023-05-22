import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/enum/report_type.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/deletable_photo_view.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/modules/report/views/report_item_view.dart';
import '../../../core/utils/inset_tool.dart';
import '../../../core/widget/custom_button.dart';
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({Key? key}) : super(key: key);

  Widget gridView(BuildContext _context) {
    final count = controller.assetsController.photos.length == 3
        ? controller.assetsController.photos.length
        : controller.assetsController.photos.length + 1;
    return Container(
      child: GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: count,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: (Get.width - 34) / 3,
              childAspectRatio: 3 / 4,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1),
          itemBuilder: ((context, index) {
            if (index == controller.assetsController.photos.length) {
              return DeletablePhotoView(
                canAddPhoto: true,
                addCallback: () {
                  controller.assetsController
                      .pickAssetsWith(context: _context, maxCount: 3);
                },
              );
            } else {
              return DeletablePhotoView(
                iconUrl: controller.assetsController.photos[index],
                canAddPhoto: false,
                deleteCallback: (icon) {
                  controller.assetsController
                      .deletePhoto(controller.assetsController.photos[index]);
                },
              );
            }
          })),
    );
  }

  List<ReportType> allCases() {
    return [
      ReportType.scammer,
      ReportType.sendingSpam,
      ReportType.stolenPhoto,
      ReportType.rudeOrAbusive,
      ReportType.inappropriateContent
    ];
  }

  Widget reportItemsWidget() {
    final _controller = Get.find<ReportController>();
    final List<Widget> itemWidgets =
        allCases().map<ReportItemView>((ReportType type) {
      return ReportItemView(
        type: type,
        icon: _controller.selectedItems.contains(type)
            ? Image.asset(Assets.reportChooseSelect)
            : Image.asset(Assets.reportChooseNormal),
      );
    }).toList();
    return Container(
        child: Column(
      children: itemWidgets,
    ));
  }

  Widget textfiledWidget() {
    return SizedBox(
        height: 126,
        child: TextField(
            onChanged: (value) {
              print(value);
              controller.content.value = value;
            },
            style: textStyle(
                type: TextType.regular,
                color: ThemeColors.c1f2320,
                fontSize: 16),
            cursorColor: ThemeColors.c1f2320,
            maxLength: 200,
            maxLines: null,
            expands: true,
            textInputAction: TextInputAction.done,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.start,
            // strutStyle: StrutStyle(height: 126, forceStrutHeight: true),
            decoration: InputDecoration(
              contentPadding:
                  Insets.insetsWith(type: InsetsType.all, margin: 0),
              border: OutlineInputBorder(borderSide: BorderSide.none),
              hintStyle:
                  textStyle(type: TextType.regular, color: ThemeColors.c7f8a87),
              hintText: "Tell us more...",
              counterStyle: textStyle(
                  type: TextType.regular,
                  color: ThemeColors.c7f8a87,
                  fontSize: 12),
            )));
  }

  Widget confirmWidget() {
    final state = controller.selectedItems.length > 0 &&
            controller.content.value.length > 0
        ? CustomButtonState.selected
        : CustomButtonState.disable;
    final button = CustomButton(
        state: state,
        titleForNormal: "Report",
        onTap: () async {
          final cancelLoading = showLoading();
          final success = await controller.report();
          cancelLoading();
          Get.back();
          if (success) {
            HeySnackBar.showSuccess("Success");
          } else {
            HeySnackBar.showError("error");
          }
        });
    return button;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          titleText: "Report",
          iconThemeColor: Colors.black,
          isBackButtonEnabled: true,
        ),
        body: GestureDetector(
            child: SafeArea(
                child: Container(
              padding:
                  Insets.insetsWith(type: InsetsType.leftRight, margin: 20),
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Obx(() => reportItemsWidget()),
                      Insets.bottom(margin: 20),
                      textfiledWidget(),
                      Insets.bottom(margin: 10),
                      Obx(() => gridView(context)),
                      Insets.bottom(margin: 20),
                      Obx(() => confirmWidget()),
                    ],
                  )),
            )),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            }));
  }
}
