import 'package:get/get.dart';
import 'package:heyya/app/modules/profile/controllers/block_list_controller.dart';

import 'package:heyya/app/modules/profile/controllers/likes_me_controller.dart';
import 'package:heyya/app/modules/profile/controllers/matched_controller.dart';
import 'package:heyya/app/modules/profile/controllers/my_likes_controller.dart';
import 'package:heyya/app/modules/profile/controllers/visitors_controller.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorsController>(
      () => VisitorsController(),
    );
    Get.lazyPut<MatchedController>(
      () => MatchedController(),
    );
    Get.lazyPut<MyLikesController>(
      () => MyLikesController(),
    );
    Get.lazyPut<LikesMeController>(
      () => LikesMeController(),
    );
    Get.lazyPut<BlockListController>(
      () => BlockListController(),
    );
    Get.put(ProfileController());
  }
}
