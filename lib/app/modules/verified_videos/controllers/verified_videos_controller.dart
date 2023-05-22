import 'package:get/get.dart';
import 'package:heyya/app/core/enum/media_state.dart';
import 'package:heyya/app/core/utils/file_cache.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/enum/media_type.dart';
import '../../../core/utils/app_manager.dart';
import '../../../core/utils/get_bottom_alert.dart';
import '../../../core/utils/get_bottom_sheet.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widget/heyya_loading_indicator.dart';
import '../../../data/repository/media_repository.dart';
import '../../../routes/app_pages.dart';
import '../../video/models/video_preview_model.dart';

class VerifiedVideosController extends GetxController {
  RxList<MediaEntity> videos = RxList<MediaEntity>();

  bool isFromProfile = false;

  bool isRecordEnable() {
    return true;
    // final mainVideos =
    //     videos.where((e) => e.type == MediaType.MAIN_VIDEO).toList();
    // if (mainVideos.length > 0) {
    //   final main = mainVideos.first;
    //   return main.verifyState == MediaState.CHECKED;
    // } else {
    //   return true;
    // }
  }

  toPreview(MediaEntity entity) {
    List<Permission> permissions = [
      Permission.microphone,
      Permission.camera,
    ];
    if (GetPlatform.isAndroid) {
      permissions.add(Permission.speech);
    }
    AppManager.shared
        .checkPermission(permissions,
            tipContent:
                'Heyya needs access to your camera/microphone. So you can take video to complete your profile.')
        .then((value) {
      if (value) {
        final preview = VideoPreviewModel(
            previewType: VideoPreviewType.edit, video: entity);
        Get.toNamed(Routes.VIDEO_PREVIEW, arguments: preview);
      }
    });
  }

  setToMainVideo(MediaEntity entity) async {
    final cancelLoading = showLoading();
    try {
      await MediaRepository().setMainMedia(entity.id);
      await Get.find<VerifiedVideosController>().updateProfile();
      cancelLoading();
    } catch (_) {
      cancelLoading();
    }
  }

  showHeyyaMoreAction(MediaEntity entity) {
    if (entity.verifyState == MediaState.CHECKED) {
      final actions = <GetBottomSheetAction>[];
      if (entity.type == MediaType.VERIFY_VIDEO) {
        actions.add(GetBottomSheetAction(
            title: "Set as main",
            onTap: () async {
              Get.back();
              setToMainVideo(entity);
            }));
      }
      actions.addAll([
        // GetBottomSheetAction(
        //     title: "Save",
        //     onTap: () async {
        //       Get.back();
        //     }),
        GetBottomSheetAction(
            title: "Share",
            onTap: () async {
              Get.back();
              final url = entity.url;
              Share.share(
                url,
                subject: "Heyya: 100% Real Video",
              );
            }),
        GetBottomSheetAction(
            title: "Delete",
            titleColor: ThemeColors.cfe4281,
            onTap: () {
              Get.back();
              showDeleteAlert(entity);
            })
      ]);
      GetBottomSheet.showActions(actions);
    } else {
      GetBottomSheet.showActions([
        GetBottomSheetAction(
            title: "Delete",
            titleColor: ThemeColors.cfe4281,
            onTap: () {
              Get.back();
              showDeleteAlert(entity);
            })
      ]);
    }
  }

  showDeleteAlert(MediaEntity entity) {
    GetBottomAlert.showDeleteVideoAlert(cancelCallback: () {
      Get.back();
      performDelete(entity);
    }, doneCallback: () {
      Get.back();
    });
  }

  performDelete(MediaEntity entity) async {
    var cancelLoading = showLoading();
    await MediaRepository().deleteMedia(entity.id);
    cancelLoading();
    Get.find<VerifiedVideosController>().updateProfile();
    // final videos = Session.getUser()
    //     ?.medias
    //     ?.where((element) =>
    //         (element.type == MediaType.VERIFY_VIDEO) ||
    //         element.type == MediaType.MAIN_VIDEO)
    //     .toList();
    // if (videos != null) {
    //   videos.removeWhere((element) => element.id == entity.id);
    //   Get.find<VerifiedVideosController>().videos.value = videos;
    // }
    // update();
  }

  updateProfile() async {
    await UserManager.updateUserProfile();
    for (var element in Session.getUser()?.medias ?? []) {
      var video = element as MediaEntity;
      if (video.type == MediaType.PICTURE) {
        continue;
      }
      if (video.url.isNotEmpty) {
        EMCache.shared.saveFile(EMFileType.video, url: video.url);
      }
    }
    updateUI();
  }

  updateUI() {
    final medias = Session.getUser()?.medias;
    if (medias != null) {
      // medias.sort(((a, b) {
      //   // return a.id.length.compareTo(b.id.length);
      //   return (a.type == MediaType.MAIN_VIDEO ||
      //           a.type == MediaType.VERIFY_VIDEO)
      //       ? 1
      //       : 0;
      // }));
      final main = medias
          .firstWhereOrNull((element) => element.type == MediaType.MAIN_VIDEO);
      if (main != null) {
        medias.removeWhere((element) => element.type == MediaType.MAIN_VIDEO);
        medias.insert(0, main);
      }
      videos.value = medias;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    updateUI();
  }

  @override
  void onReady() {
    super.onReady();
    updateProfile();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
