import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/widget/extended_video.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/model/spark_entity.dart';
import 'package:heyya/app/modules/spark/widgets/spark_card_intro.dart';
import 'package:heyya/app/routes/app_pages.dart';

class SparkCard extends StatelessWidget {
  const SparkCard({
    Key? key,
    required this.entity,
    this.onAvatar,
    this.onMore,
    this.autoPlay = false,
    this.isSwipedComplete = false,
  }) : super(key: key);

  final SparkEntity entity;
  final VoidCallback? onAvatar;
  final VoidCallback? onMore;
  final bool autoPlay;
  final bool isSwipedComplete;

  Widget get _avatarView {
    return Positioned(
        left: 15.0,
        top: 15.0,
        child: GestureDetector(
          onTap: onAvatar,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: SizedBox(
              width: 40.0,
              height: 40.0,
              child: _avatarImage(entity),
            ),
          ),
        ));
  }

  Widget _avatarImage(SparkEntity entity) {
    final avatar = entity.avatar;
    if (avatar != null && avatar.isNotEmpty) {
      return _imageUrlCover(avatar);
    } else {
      return ExtendedImage.asset(
        Assets.imageBgAvatar,
        fit: BoxFit.cover,
      );
    }
  }

  Widget get _moreButton {
    return Positioned(
      right: 15.0,
      top: 15.0,
      child: GestureDetector(
        onTap: onMore,
        child: ExtendedImage.asset(Assets.sparkMore),
      ),
    );
  }

  Widget get _errorView {
    return ExtendedImage.asset(
      Assets.sparkPictureFail,
      fit: BoxFit.cover,
    );
  }

  Widget _imageUrlCover(String url) {
    return ExtendedImage.network(
      url,
      fit: BoxFit.cover,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.failed) {
          return ExtendedImage.asset(
            Assets.imageBgAvatar,
            fit: BoxFit.cover,
          );
        }
        return null;
      },
    );
  }

  Widget? _videoCover(String? cover, String? avatar) {
    if (cover != null && cover.isNotEmpty) {
      return ExtendedImage.network(cover, fit: BoxFit.cover,
          loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.failed) {
          return UnconstrainedBox(
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return null;
      });
    } else if (avatar != null && avatar.isNotEmpty) {
      return ExtendedImage.network(avatar, fit: BoxFit.cover,
          loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.failed) {
          return UnconstrainedBox(
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return null;
      });
    } else {
      return UnconstrainedBox(
        child: Center(
          child: const CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget get _mediaView {
    MediaEntity? media;
    final mainMedias = entity.medias
        .where((element) => element.type == MediaType.MAIN_VIDEO)
        .toList();
    final verifyMedias = entity.medias
        .where((element) => element.type == MediaType.VERIFY_VIDEO)
        .toList();
    if (mainMedias.length > 0) {
      media = mainMedias.first;
    } else if (verifyMedias.length > 0) {
      media = verifyMedias.first;
    }

    final avatar = entity.avatar;
    if (media == null) {
      if (avatar != null && avatar.isNotEmpty) {
        return _imageUrlCover(avatar);
      } else {
        return ExtendedImage.asset(
          Assets.imageBgAvatar,
          fit: BoxFit.cover,
        );
      }
    } else {
      return ExtendedVideo(
        video: media,
        autoPlay: autoPlay,
        isComplete: isSwipedComplete,
        errorBuilder: (context) {
          return _errorView;
        },
        thumbnailBuilder: (context) {
          final cover = media?.cover;
          final avatar = entity.avatar;
          return _videoCover(cover, avatar);
        },
      );
    }
  }

  Widget get _contentView {
    return Positioned.fill(
      child: _mediaView,
    );
  }

  Widget get _introView {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.USER_PROFILE, arguments: entity.toUser());
        },
        child: Container(
          color: Colors.transparent,
          child: SparkCardIntro(
            name: entity.nickname ?? '',
            selfIntro: entity.aboutMe ?? '',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            _contentView,
            _introView,
            _avatarView,
            _moreButton,
          ],
        ),
      ),
    );
  }
}
