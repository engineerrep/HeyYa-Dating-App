import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/utils/file_cache.dart';
import 'package:heyya/app/data/model/short_video_entity.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final ShortVideoEntity shortVideoEntity;
  final int index;
  final GlobalKey gkey;
  final bool autoLoadVideo;

  const VideoPlayerWidget(
      {required this.shortVideoEntity,
      required this.index,
      required this.gkey,
      this.autoLoadVideo = false})
      : super(key: gkey);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();

  VideoPlayerController? getVideoPlayerController() {
    var state = gkey.currentState;
    if (state is _VideoPlayerWidgetState) {
      return state.videoPlayerController;
    }
    return null;
  }

  void setShouldPlayVideoStatus(bool status) {
    var state = gkey.currentState;
    if (state is _VideoPlayerWidgetState) {
      state.shouldPlayVideo = status;
    }
  }

  void playVideo() {
    var state = gkey.currentState;
    if (state is _VideoPlayerWidgetState) {
      state.loadVideo();
    }
  }

  void stopVideo() {
    var state = gkey.currentState;
    if (state is _VideoPlayerWidgetState) {
      state.videoPlayerController = null;
    }
  }
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? videoPlayerController;
  bool shouldPlayVideo = false;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.autoLoadVideo) {
      shouldPlayVideo = true;
      loadVideo();
    }
  }

  void loadVideo() {
    if (videoPlayerController != null) {
      return;
    }
    File? file = EMCache.shared.getFileSync(
        widget.shortVideoEntity.video?.url ?? 'unknown', EMFileType.video);
    if (file != null) {
      videoPlayerController = VideoPlayerController.file(file);
    } else {
      videoPlayerController = VideoPlayerController.network(
          widget.shortVideoEntity.video?.url ?? '');
    }

    videoPlayerController?.setLooping(true);
    videoPlayerController?.addListener(() {
      if (videoPlayerController != null) {
        setState(() {
          currentDuration = videoPlayerController!.value.position;
        });
      }
    });
    videoPlayerController?.initialize().then((value) {
      setState(() {
        if (shouldPlayVideo && videoPlayerController != null) {
          if (videoPlayerController!.value.isInitialized) {
            // 获取总时长
            totalDuration = videoPlayerController!.value.duration;

            if (!videoPlayerController!.value.isPlaying) {
              videoPlayerController?.play();
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    if (videoPlayerController != null) {
      videoPlayerController?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    double percent = totalDuration.inMilliseconds != 0
        ? currentDuration.inMicroseconds *
            1.0 /
            totalDuration.inMicroseconds *
            1.0
        : 0;
    if (percent > 1.0) {
      percent = 1.0;
    } else if (percent < 0.0) {
      percent = 0.0;
    }

    BoxDecoration coverBoxDecoration;
    final cover = widget.shortVideoEntity.video?.cover;
    final avatar = widget.shortVideoEntity.user?.avatar;
    if (cover != null && cover.isNotEmpty) {
      coverBoxDecoration = BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: Image.network(cover).image, fit: BoxFit.contain));
    } else if (avatar != null && avatar.isNotEmpty) {
      coverBoxDecoration = BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: Image.network(avatar).image, fit: BoxFit.contain));
    } else {
      coverBoxDecoration = BoxDecoration(color: Colors.white);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () {
            if (videoPlayerController != null) {
              if (videoPlayerController!.value.isInitialized) {
                if (videoPlayerController!.value.isPlaying) {
                  videoPlayerController?.pause();
                } else {
                  videoPlayerController?.play();
                }
                setState(() {});
              }
            }
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: coverBoxDecoration,
                  child: videoPlayerController != null
                      ? (videoPlayerController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio:
                                  videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController!),
                            )
                          : Container())
                      : Container(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: videoPlayerController != null
                      ? (videoPlayerController!.value.isInitialized
                          ? ((videoPlayerController!.value.isPlaying ||
                                  videoPlayerController!.value.isBuffering)
                              ? 0
                              : 1)
                          : 0)
                      : 0,
                  child: Image.asset(Assets.sparkPause),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GFProgressBar(
            animation: true,
            animationDuration: 500,
            animateFromLastPercentage: true,
            percentage: percent,
            margin: EdgeInsets.zero,
            progressBarColor: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.6),
            lineHeight: 1.5,
          ),
        )
      ],
    );
  }
}
