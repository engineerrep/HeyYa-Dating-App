import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/assets/assets_images.dart';
import 'package:heyya/app/core/heyya_exports.dart';
import 'package:heyya/app/core/utils/im_manager.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/data/model/relation_user_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/routes/app_pages.dart';

class HeyyaListCell extends StatelessWidget {
  RelationUserEntity relation;
  HeyyaListCell({super.key, required this.relation});

  BoxDecoration _decoration() {
    final avatar = relation.toUser.avatar;
    if (avatar != null && avatar.isNotEmpty) {
      return BoxDecoration(
          image: DecorationImage(
              image: ExtendedImage.network(avatar).image, fit: BoxFit.cover),
          color: ThemeColors.randomSparkTitleColor(),
          borderRadius: BorderRadius.circular(8));
    } else {
      return BoxDecoration(
          color: ThemeColors.randomSparkTitleColor(),
          borderRadius: BorderRadius.circular(8));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.USER_PROFILE, arguments: relation.toUser);
      },
      child: Container(
          decoration: _decoration(),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomCenter,
            children: [
              ExtendedImage(
                image: AssetImages.sparkMask,
                alignment: Alignment.bottomCenter,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      GestureDetector(
                          child:
                              ExtendedImage(image: AssetImages.iconMessageList),
                          onTapUp: (_) {
                            final uid = relation.toUser.id;
                            if (uid != null) {
                              ImManager.shared.chatWithUser(
                                  userId: uid,
                                  showName: relation.toUser.nickname);
                            }
                          }),
                    ],
                  ),
                  Expanded(child: Container()),
                  Container(
                    padding: Insets.insetsWith(
                        type: InsetsType.leftRight, margin: 10),
                    child: Text(
                      relation.toUser.nickname ?? "Null",
                      style: textStyle(
                          fontSize: 16,
                          color: ThemeColors.randomSparkTitleColor()),
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    padding: Insets.insetsWith(
                        type: InsetsType.leftRight, margin: 10),
                    child: Text(
                      relation.toUser.aboutMe ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 13),
                ],
              ),
            ],
          )),
    );
  }
}
