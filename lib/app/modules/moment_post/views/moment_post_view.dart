import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_button.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/core/widget/deletable_photo_view.dart';
import 'package:heyya/app/core/widget/heyya_assets_picker_builder.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/modules/moment/controllers/moment_controller.dart';

import '../../../core/assets/assets.dart';
import '../../../core/utils/inset_tool.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_fonts.dart';
import '../controllers/moment_post_controller.dart';

class MomentPostView extends GetView<MomentPostController> {
  MomentPostView({Key? key}) : super(key: key);

  final assetPickerController = Get.find<HeyyaAssetsPickerController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: CustomAppBar(titleText: "Favorite Moments"),
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
    final state = (assetPickerController.photos.isNotEmpty &&
            controller.content.value.isNotEmpty)
        ? CustomButtonState.selected
        : CustomButtonState.disable;
    final button = CustomButton(
        state: state,
        titleForNormal: "Post",
        onTap: () async {
          final cancelLoading = showLoading();
          final success = await controller.postMoment();
          cancelLoading();
          if (success) {
            Get.find<MomentController>().loadNext(true);
            Get.back();
          }
        });
    return button;
  }

  Widget gridView(BuildContext _context) {
    final count = assetPickerController.photos.length == 9
        ? assetPickerController.photos.length
        : assetPickerController.photos.length + 1;
    return Container(
      child: GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: count,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: (Get.width - 34) / 3,
              childAspectRatio: 3 / 4,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2),
          itemBuilder: ((context, index) {
            if (index == assetPickerController.photos.length) {
              return DeletablePhotoView(
                canAddPhoto: true,
                addCallback: () =>
                    assetPickerController.pickAssetsWith(context: _context),
              );
            } else {
              return DeletablePhotoView(
                iconUrl: assetPickerController.photos[index],
                canAddPhoto: false,
                deleteCallback: (icon) {
                  print("delete: $icon");
                  // controller.photos.clear();
                  assetPickerController.deletePhoto(icon);
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
              textInputAction: TextInputAction.done,
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
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding:
                    Insets.insetsWith(type: InsetsType.all, margin: 0),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintStyle: textStyle(
                    type: TextType.regular, color: ThemeColors.c7f8a87),
                hintText: "Ex: I enjoy hiking with my friends…",
                counterStyle: textStyle(
                    type: TextType.regular,
                    color: ThemeColors.c7f8a87,
                    fontSize: 12),
              )),
        ));
  }
}
