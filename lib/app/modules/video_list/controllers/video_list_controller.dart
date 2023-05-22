import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/utils/file_cache.dart';
import 'package:heyya/app/core/utils/get_bottom_sheet.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/utils/im_manager.dart';
import 'package:heyya/app/data/model/page_info_entity.dart';
import 'package:heyya/app/data/model/short_video_entity.dart';
import 'package:heyya/app/data/repository/heyya_list_repostitory.dart';
import 'package:heyya/app/data/repository/spark_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/report/models/report_block_state.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:heyya/app/modules/video_list/views/video_player.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:heyya/app/network/exceptions/network_exception.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';

class VideoListController extends GetxController {
  late Worker _blockWorker;
  final HeyyaListRepository repository = HeyyaListRepository();

  final SparkRepository _repository = SparkRepository();
  int currentPlayIndex = 0;
  bool isFirstPlay = true;
  bool isLoading = false;

  late PageController pageController;
  PageInfoRequest pageInfo = PageInfoRequest(number: 1, size: 10);
  PageInfoEntity<ShortVideoEntity>? pageInfoEntity;

  List<VideoPlayerWidget> videoWidgets = [];

  Future<void> getVideosList(bool isRefresh, {String? userId}) async {
    try {
      if (isLoading || (pageInfoEntity?.hasNextPage ?? true) == false) {
        return;
      }
      isLoading = true;
      if (isRefresh) {
        pageInfo = PageInfoRequest(number: 1, size: pageInfo.size);
      } else {
        pageInfo =
            PageInfoRequest(number: pageInfo.number + 1, size: pageInfo.size);
      }

      final response =
          await repository.getVideoListPageInfos(pageInfoReq: pageInfo);

      List<ShortVideoEntity> videos =
          isRefresh ? [] : pageInfoEntity?.list ?? [];
      if (response.list.isNotEmpty) {
        for (ShortVideoEntity element in response.list) {
          if (element.video?.url == null) {
            continue;
          }
          videos.add(element);
          var video = element.video;
          if (video != null && video.url.isNotEmpty) {
            EMCache.shared.saveFile(EMFileType.video, url: video.url);
          }
        }
      }
      response.list = videos;
      pageInfoEntity = response;
      isLoading = false;

      update();
    } on NetworkException catch (e) {
      // EasyLoading.showError(e.message);
      isLoading = false;
    }
  }

  Future<void> stopVideo(int index) async {
    if (videoWidgets.length > index && index >= 0) {
      VideoPlayerWidget videoPlayerWidget = videoWidgets[index];
      videoPlayerWidget.setShouldPlayVideoStatus(false);

      VideoPlayerController? playerController =
          videoPlayerWidget.getVideoPlayerController();
      if (playerController != null) {
        playerController.value.isPlaying ? playerController.pause() : null;
        await playerController.dispose();
        videoPlayerWidget.stopVideo();
      }
    }
  }

  void playVideo(int index) async {
    if (videoWidgets.length > index) {
      VideoPlayerWidget videoPlayerWidget = videoWidgets[index];
      videoPlayerWidget.setShouldPlayVideoStatus(true);
      videoPlayerWidget.playVideo();
      currentPlayIndex = index;

      if (currentPlayIndex > ((pageInfoEntity?.list.length ?? 5) - 5)) {
        getVideosList(false);
      }
    }
  }

  Future<void> pauseVideo() async {
    if (isFirstPlay) {
      isFirstPlay = false;
      return;
    }

    if (videoWidgets.length > currentPlayIndex) {
      VideoPlayerWidget videoPlayerWidget = videoWidgets[currentPlayIndex];
      videoPlayerWidget.setShouldPlayVideoStatus(false);

      VideoPlayerController? playerController =
          videoPlayerWidget.getVideoPlayerController();
      if (playerController != null) {
        if (playerController.value.isPlaying) {
          await playerController.pause();
          update();
        }
      }
    }
  }

  void userBlocked(String userId) async {
    if (pageInfoEntity?.list.isEmpty ?? true) {
      return;
    }

    await pauseVideo();

    videoWidgets
        .removeWhere((element) => element.shortVideoEntity.user?.id == userId);
    pageInfoEntity?.list.removeWhere((element) => element.user?.id == userId);

    update();
  }

  void addVideo() {
    Get.toNamed(Routes.VIDEO_TOPIC);
  }

  void onMore() {
    final entity = pageInfoEntity?.list[currentPlayIndex];
    GetBottomSheet.showHeyyaReprt(userId: entity?.user?.id ?? "");
  }

  void onForward(ShortVideoEntity videoEntity) {
    final url = videoEntity.video?.url;
    if (url != null) {
      Share.share(
        url,
        subject: "Heyya: 100% Real Video",
      );
    }
  }

  void onMessage(ShortVideoEntity videoEntity) {
    ImManager.shared.chatWithUser(
        userId: videoEntity.user?.id ?? "",
        showName: videoEntity.user?.nickname ?? "");
  }

  void like(ShortVideoEntity videoEntity) async {
    if (videoEntity.user?.liked ?? false) {
      HeySnackBar.showSuccess("You liked this user.");
    } else {
      try {
        await _repository.like(int.parse(videoEntity.user?.id ?? ""));
        final relation = Session.getRelation();
        if (relation != null) {
          relation.myLikeNum += 1;
          Session.shard().updateRelation(relation);
        }
        final videoEntities = pageInfoEntity?.list;
        if (videoEntities != null) {
          for (var entity in videoEntities) {
            if (entity.user?.id == videoEntity.user?.id) {
              entity.user?.liked = true;
            }
          }
          update();
        }
      } catch (e) {
        HeySnackBar.showError(e is BaseException ? e.message : e.toString());
      }
    }
  }

  @override
  void onInit() {
    super.onInit();

    pageController = PageController();

    getVideosList(true);
  }

  @override
  void onReady() {
    super.onReady();
    _blockWorker =
        ever(Get.find<ReportBlockState>().didBlockUserId, _onListenBlockUser);
  }

  @override
  void onClose() {
    super.onClose();
    _blockWorker.dispose();
  }

  void _onListenBlockUser(String blockedUserId) {
    userBlocked(blockedUserId);
  }
}
