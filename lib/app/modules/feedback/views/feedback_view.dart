import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/widget/deletable_photo_view.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import '../../../core/utils/inset_tool.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_fonts.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../core/widget/custom_button.dart';
import '../../../core/widget/custom_scaffold.dart';
import '../controllers/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: CustomAppBar(titleText: "Feedback"),
      body: SafeArea(
          child: Container(
        padding: Insets.insetsWith(type: InsetsType.leftRight),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              textfiledWidget(),
              Insets.bottom(margin: 20),
              Obx(() => gridView(context)),
              Insets.bottom(margin: 20),
              Obx(() => confirmWidget()),
            ],
          ),
        ),
      )),
    );
  }

  Widget confirmWidget() {
    final state = (controller.assetsController.photos.length > 0 &&
            controller.content.value.length > 0)
        ? CustomButtonState.selected
        : CustomButtonState.normal;
    final button =
        CustomButton(state: state, titleForNormal: "Done", onTap: confirmClick);
    return button;
  }

  void confirmClick() async {
    final cancelLoading = showLoading();
    final success = await controller.feedback();
    cancelLoading();
    if (success) {
      Get.back();
      HeySnackBar.showSuccess("Success");
    }
  }

  Widget gridView(BuildContext context) {
    final maxPhotoCount = 3;
    final photosCount = controller.assetsController.photos.length;
    final count = photosCount == maxPhotoCount
        ? maxPhotoCount
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
            if (index == photosCount) {
              return DeletablePhotoView(
                canAddPhoto: true,
                addCallback: () {
                  controller.assetsController.pickAssetsWith(
                      context: context, maxCount: maxPhotoCount);
                },
              );
            } else {
              return DeletablePhotoView(
                iconUrl: controller.assetsController.photos[index],
                canAddPhoto: false,
                deleteCallback: (icon) {
                  print("delete: $icon");
                  controller.assetsController.deletePhoto(icon);
                },
              );
            }
          })),
    );
  }

  Widget textfiledWidget() {
    return SizedBox(
        height: 170,
        child: Container(
          color: Colors.white,
          padding: Insets.insetsWith(type: InsetsType.all, margin: 16),
          child: TextField(
              onChanged: (value) {
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
              decoration: InputDecoration(
                contentPadding:
                    Insets.insetsWith(type: InsetsType.all, margin: 0),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintStyle: textStyle(
                    type: TextType.regular, color: ThemeColors.c7f8a87),
                hintText: "Say something...",
                counterStyle: textStyle(
                    type: TextType.regular,
                    color: ThemeColors.c7f8a87,
                    fontSize: 12),
              )),
        ));
  }
}
