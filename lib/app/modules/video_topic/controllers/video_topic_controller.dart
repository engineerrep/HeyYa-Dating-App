// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoTopicController extends GetxController {
  doneClick() {
    //拍摄普通视频: 拍摄或上传视频
    //提示、进入拍摄界面、拍摄成功后进入预览、重拍或完成拍摄
    List<Permission> permissions = [
      Permission.microphone,
      Permission.camera,
    ];
    AppManager.shared
        .checkPermission(permissions,
            tipContent:
                'Heyya needs access to your camera/microphone. So you can take a video.')
        .then((value) {
      if (value) {
        if (!UserProfile.completeVideoIfNeeded(true)) {
          Get.toNamed(Routes.VIDEO_TOPIC_RECORD,
              arguments: selectedItems.value);
        }
      }
    });
  }

  final title = "Topic";
  final subTitle =
      "Choose the topic of the video you shoot to let users know your preferences. Add up to three topics!";

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxList<VideoTopicItem> selectedItems = <VideoTopicItem>[].obs;

  final List<VideoTopicItem> allItems = [
    VideoTopicItem("Workout", Assets.topicHomeWorkout),
    VideoTopicItem("Foodie Tour", Assets.topicFoodieTour),
    VideoTopicItem("Fashion", Assets.topicFashion),
    VideoTopicItem("Photography", Assets.topicPhotography),
    VideoTopicItem("Reading", Assets.topicReading),
    VideoTopicItem("Sports", Assets.topicSports),
    VideoTopicItem("Shopping", Assets.topicShopping),
    VideoTopicItem("Cars", Assets.topicCars),
    VideoTopicItem("Travel", Assets.topicTravel),
    VideoTopicItem("Skincare", Assets.topicSkincare),
    VideoTopicItem("Coffee", Assets.topicCoffee),
    VideoTopicItem("E-Sports", Assets.topicESports),
    VideoTopicItem("Cosplay", Assets.topicCosplay),
    VideoTopicItem("Cooking", Assets.topicCooking),
    VideoTopicItem("Art", Assets.topicArt),
    VideoTopicItem("Environmentalism", Assets.topicEnvironmentalism),
    VideoTopicItem("Vegan Cooking", Assets.topicVeganCooking),
    VideoTopicItem("Anime", Assets.topicAnime),
  ];
}

class VideoTopicItem {
  String title;
  String iconName;
  bool isSelected;
  VideoTopicItem(this.title, this.iconName, {this.isSelected = false});
}
