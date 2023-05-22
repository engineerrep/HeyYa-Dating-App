import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_constant.dart';
import 'package:heyya/app/core/widget/heyya_container.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class DeletablePhotoView extends StatelessWidget {
  final String? iconUrl;
  final bool canAddPhoto;
  final VoidCallback? addCallback;
  final StringCallback? deleteCallback;

  DeletablePhotoView(
      {Key? key,
      this.iconUrl,
      this.canAddPhoto = false,
      this.addCallback,
      this.deleteCallback})
      : super(key: key);

  DecorationImage? get _decorationImage {
    if (iconUrl != null) {
      return DecorationImage(
        image: ExtendedImage.file(
          File(iconUrl!),
        ).image,
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (canAddPhoto) {
      return GestureDetector(
          child: Container(
            child: ExtendedImage.asset(
              Assets.reportPhotoAdd,
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            if (canAddPhoto) {
              addCallback?.call();
            }
          });
    } else {
      return Container(
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          color: Colors.white,
          image: _decorationImage,
        ),
        child: GestureDetector(
          child: ExtendedImage.asset(
            Assets.reportPhotoCancel,
          ),
          onTap: () {
            deleteCallback?.call(iconUrl ?? '');
          },
        ),
        padding: Insets.insetsWith(type: InsetsType.right, margin: 0),
      );
    }
  }
}
