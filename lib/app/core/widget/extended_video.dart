import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/utils/file_cache.dart';
import 'package:heyya/app/core/utils/video_thumbnail_wrapper.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class ExtendedVideo extends StatefulWidget {
  const ExtendedVideo({
    Key? key,
    required this.video,
    this.onTap,
    this.autoPlay = false,
    this.isComplete = false,
    this.loadingBuilder,
    this.thumbnailBuilder,
    this.errorBuilder,
  }) : super(key: key);

  final MediaEntity video;
  final VoidCallback? onTap;
  final bool autoPlay;
  final bool isComplete;
  final Function(BuildContext context)? loadingBuilder;
  final Function(BuildContext context)? thumbnailBuilder;
  final Function(BuildContext context)? errorBuilder;

  @override
  State<StatefulWidget> createState() {
    return ExtendedVideoState();
  }
}

class ExtendedVideoState extends State<ExtendedVideo> {
  VideoPlayerController? _videoPlayerController;

  final _isPlaying = false.obs;
  bool _hasError = false;
  bool _isInitializing = false;
  bool get _isInitialized =>
      _videoPlayerController?.value.isInitialized ?? false;
  VideoThumbnailData? _thumbnail;
  bool get _isVideoPlayerControllerPlaying =>
      _videoPlayerController?.value.isPlaying ?? false;
  bool? _manuallyPlay;
  bool _isVisible = true;

  double get _videoWidth {
    if (_isInitialized) {
      return _videoPlayerController!.value.size.width;
    } else if (_thumbnail != null) {
      return _thumbnail!.width.toDouble();
    }
    return 0.0;
  }

  double get _videoHeight {
    if (_isInitialized) {
      return _videoPlayerController!.value.size.height;
    } else if (_thumbnail != null) {
      return _thumbnail!.height.toDouble();
    }
    return 0.0;
  }

  // double get _aspectRatio {
  //   double aspectRatio = 1.0;
  //   if (_videoHeight != 0.0) {
  //     aspectRatio = _videoWidth / _videoHeight;
  //   }
  //   return aspectRatio;
  // }

  @override
  void initState() {
    super.initState();

    _initializeVideoThumbnail();
  }

  @protected
  @override
  void didUpdateWidget(ExtendedVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.video != oldWidget.video) {
      setState(() {
        _reload();
      });
    } else if (widget.autoPlay && !_isInitialized) {
      _initializePlayerController();
    } else if (widget.isComplete) {
      _videoPlayerController?.pause();
    }
  }

  @override
  void dispose() {
    _disposePlayerController();
    super.dispose();
  }

  _onAppear() {
    _isVisible = true;
    if (widget.autoPlay && (_manuallyPlay ?? true)) {
      _videoPlayerController?.play();
    }
  }

  _onDisappear() {
    _isVisible = false;
    _videoPlayerController?.pause();
  }

  _reload() async {
    _hasError = false;
    _thumbnail = null;
    _manuallyPlay = false;
    _disposePlayerController();
    _initializeVideoThumbnail();
  }

  _initializeVideoThumbnail() async {
    if (widget.thumbnailBuilder != null) {
      if (widget.autoPlay && _isInitialized == false) {
        _initializePlayerController();
      }
      return;
    }

    handleThumbnail(VideoThumbnailData? data) {
      if (mounted) {
        if (data != null) {
          setState(() {
            _thumbnail = data;
          });
          if (widget.autoPlay && _isInitialized == false) {
            _initializePlayerController();
          }
        } else {
          _initializePlayerController();
        }
      }
    }

    VideoThumbnailWrapper.getVideoThumbnailFile(widget.video.url).then((data) {
      handleThumbnail(data);
    }).catchError((_) {
      handleThumbnail(null);
    });
  }

  _initializePlayerController() async {
    if (_isInitializing) {
      return;
    }
    await _disposePlayerController();
    //缓存机制
    File? file = EMCache.shared.getFileSync(widget.video.url, EMFileType.video);
    if (file != null) {
      _videoPlayerController = VideoPlayerController.file(file);
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.video.url);
    }
    _videoPlayerController?.setLooping(true);

    try {
      await _videoPlayerController?.initialize();
      _videoPlayerController?.addListener(_onListenVideoPlayerController);
      if ((widget.autoPlay || _manuallyPlay == true) && _isVisible) {
        _videoPlayerController?.play();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      debugPrint("Load video fail $e");
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  _disposePlayerController() async {
    await _videoPlayerController?.pause();
    _videoPlayerController?.removeListener(_onListenVideoPlayerController);
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
  }

  _onListenVideoPlayerController() {
    if (_isPlaying.value != _isVideoPlayerControllerPlaying) {
      _isPlaying.value = _isVideoPlayerControllerPlaying;
    }
  }

  _playOrPause() {
    if (_isInitialized == false) {
      _manuallyPlay = true;
      _initializePlayerController();
      return;
    }
    if (_isPlaying.value) {
      _manuallyPlay = false;
      _videoPlayerController?.pause();
      return;
    }
    if (_videoPlayerController?.value.duration ==
        _videoPlayerController?.value.position) {
      _videoPlayerController
        ?..seekTo(Duration.zero)
        ..play();
      return;
    }
    _manuallyPlay = true;
    _videoPlayerController?.play();
  }

  Widget _loadingBuilder() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _errorBuilder() {
    return Center(
      child: GestureDetector(
        onTap: _reload,
        child: const Text("Reload"),
      ),
    );
  }

  Widget _contentBuilder() {
    return Obx(() {
      return GestureDetector(
        onTap: _isPlaying.value ? _playOrPause : widget.onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoWidth,
                    height: _videoHeight,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                ),
              ),
            if (widget.thumbnailBuilder != null && _isInitialized == false)
              widget.thumbnailBuilder!(context),
            if (_thumbnail != null && _isInitialized == false)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoWidth,
                    height: _videoHeight,
                    child: Opacity(
                      opacity: _isInitialized ? 0.0 : 1.0,
                      child: ExtendedImage.file(
                        _thumbnail!.thumbnail,
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState ==
                              LoadState.failed) {
                            return widget.errorBuilder?.call(context) ??
                                _errorBuilder();
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            Align(
              child: AnimatedOpacity(
                opacity: _isPlaying.value ? 0.0 : 1.0,
                duration: kThemeAnimationDuration,
                child: GestureDetector(
                  onTap: _playOrPause,
                  child: ExtendedImage.asset(Assets.sparkPause),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_hasError) {
      child = widget.errorBuilder?.call(context) ?? _errorBuilder();
    } else if (widget.thumbnailBuilder == null &&
        _thumbnail == null &&
        _isInitialized == false) {
      child = widget.loadingBuilder?.call(context) ?? _loadingBuilder();
    } else {
      child = _contentBuilder();
    }
    return FocusDetector(
      child: child,
      onVisibilityGained: _onAppear,
      onVisibilityLost: _onDisappear,
    );
  }
}
