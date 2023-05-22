import 'package:extended_image/extended_image.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/utils/moment_helper.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/widget/extended_image_viewer.dart';
import 'package:heyya/app/data/model/moment_entity.dart';
import 'package:lottie/lottie.dart';

class MomentListItem extends StatelessWidget {
  const MomentListItem(
      {Key? key,
      required this.entity,
      this.onMore,
      this.onLike,
      this.onChat,
      this.onUserProfile})
      : super(key: key);

  final MomentEntity entity;
  final VoidCallback? onMore;
  final VoidCallback? onLike;
  final VoidCallback? onChat;
  final VoidCallback? onUserProfile;

  Widget _contentBuilder(BuildContext context) {
    return Text(
      entity.content,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontWeight: FontWeight.normal,
          ),
    );
  }

  Widget _imagesListBuilder(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // 116.0 / 155.0
      const whRatio = 0.748;
      // 116.0 / 375.0
      const wRatio = 0.309;
      final width = constraints.maxWidth * wRatio;
      final height = width / whRatio;

      return SizedBox(
        width: constraints.maxWidth,
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: entity.medias.length,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          clipBehavior: Clip.none,
          separatorBuilder: (context, _) => const SizedBox(width: 1),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    FFTransparentPageRoute(pageBuilder: (context, _, __) {
                  return ExtendedImageViewer(
                    medias: entity.medias,
                    currentIndex: index,
                  );
                }));
              },
              child: Hero(
                tag: entity.medias[index].url,
                child: ExtendedImage.network(
                  entity.medias[index].url + '?width=300',
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return Lottie.asset(
                        'assets/lottie/moment_image_loading.json',
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                      );
                    } else if (state.extendedImageLoadState ==
                        LoadState.failed) {
                      return ExtendedImage.asset(
                        Assets.momentsPictureFail,
                        fit: BoxFit.cover,
                      );
                    }
                    return null;
                  },
                ),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: onUserProfile,
              child: MomentListItemProfile(
                avatar: entity.user.avatar ?? "",
                name: entity.user.nickname ?? "",
                atTime: MomentHelper.getMomentFormatedTime(
                    entity.id, entity.createTime),
                onMore: onMore,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          if (entity.content.isNotEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _contentBuilder(context)),
          if (entity.content.isNotEmpty) const SizedBox(height: 10.0),
          _imagesListBuilder(context),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MomentListItemActionBar(
              mediasCount: entity.medias.length,
              thumbCount: entity.thumbCount,
              isThumbUp: entity.isThumb,
              onLike: onLike,
              onChat: onChat,
            ),
          ),
        ],
      ),
    );
  }
}

class MomentListItemProfile extends StatelessWidget {
  const MomentListItemProfile({
    Key? key,
    required this.avatar,
    required this.name,
    required this.atTime,
    this.onMore,
  }) : super(key: key);

  final String avatar;
  final String name;
  final String atTime;
  final VoidCallback? onMore;

  Widget avatarView() {
    if (avatar.length > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: ExtendedImage.network(
          avatar + '?width=120',
          fit: BoxFit.cover,
          width: 40.0,
          height: 40.0,
          loadStateChanged: (state) {
            if (state.extendedImageLoadState == LoadState.failed) {
              return ExtendedImage.asset(
                Assets.imageBgAvatar,
                width: 40.0,
                height: 40.0,
              );
            }
            return null;
          },
        ),
      );
    } else {
      return ExtendedImage(image: AssetImages.messagesImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.0,
      child: Row(
        children: [
          avatarView(),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(fontSize: 16.0),
                ),
                Spacer(),
                Text(
                  atTime,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          if (onMore != null)
            GestureDetector(
              onTap: onMore,
              child: ExtendedImage.asset(Assets.momentsMore),
            ),
        ],
      ),
    );
  }
}

class MomentListItemActionBar extends StatelessWidget {
  const MomentListItemActionBar({
    Key? key,
    required this.mediasCount,
    this.thumbCount = 0,
    this.isThumbUp = false,
    this.onLike,
    this.onChat,
  }) : super(key: key);

  final int mediasCount;
  final bool isThumbUp;
  final int thumbCount;
  final VoidCallback? onLike;
  final VoidCallback? onChat;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MomentListItemActionWidget(
          icon: ExtendedImage.asset(Assets.momentsPhoto),
          text: Text(
            '$mediasCount',
            style:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 14.0),
          ),
        ),
        Spacer(),
        MomentListItemActionWidget(
          action: onLike,
          icon: isThumbUp
              ? ExtendedImage.asset(Assets.momentsLiked)
              : ExtendedImage.asset(Assets.momentsLike),
          text: Text(
            '$thumbCount',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: ThemeColors.c1f2320),
          ),
        ),
        const SizedBox(width: 30.0),
        MomentListItemActionWidget(
          action: onChat,
          icon: ExtendedImage.asset(Assets.momentsChat),
          text: Text(
            "Chat",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: ThemeColors.c1f2320),
          ),
        ),
      ],
    );
  }
}

class MomentListItemActionWidget extends StatelessWidget {
  const MomentListItemActionWidget({
    Key? key,
    required this.icon,
    required this.text,
    this.action,
  }) : super(key: key);

  final Widget icon;
  final Widget text;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 5.0),
          text,
        ],
      ),
    );
  }
}
