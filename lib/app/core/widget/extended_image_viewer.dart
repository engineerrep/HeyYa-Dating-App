import 'dart:math';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/widget/extended_video.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

/// ExtendedImageView 使用方法
// GestureDetector(
//             onTap: () {
//               final index = extendedMedias.indexOf(media);
//               Navigator.push(context,
//                   FFTransparentPageRoute(pageBuilder: (context, _, __) {
//                 return ExtendedImageViewer(
//                   currentIndex: index,
//                   medias: extendedMedias,
//                 );
//               }));
//             },
//             child: Hero(
//               tag: media.url,
//               child: media.type == ExtendedMediaType.image
//                   ? ExtendedImage.network(
//                       media.url,
//                       fit: BoxFit.cover,
//                     )
//                   : ExtendedVideo(video: media),
//             ),
//           );

class ExtendedImageViewer extends StatefulWidget {
  const ExtendedImageViewer({
    Key? key,
    required this.medias,
    this.currentIndex = 0,
  }) : super(key: key);

  final int currentIndex;
  final List<MediaEntity> medias;

  @override
  State<StatefulWidget> createState() => _ExtendedImageViewerState();
}

class _ExtendedImageViewerState extends State<ExtendedImageViewer>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ExtendedImageSlidePageState> slidePageKey =
      GlobalKey<ExtendedImageSlidePageState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ExtendedImageSlidePage(
        key: slidePageKey,
        slideAxis: SlideAxis.vertical,
        slideType: SlideType.wholePage,
        slidePageBackgroundHandler: (offset, pageSize) {
          return defaultSlidePageBackgroundHandler(
              color: Colors.black,
              offset: offset,
              pageSize: pageSize,
              pageGestureAxis: SlideAxis.vertical);
        },
        child: GestureDetector(
          onTap: () {
            slidePageKey.currentState!.popPage();
            Navigator.pop(context);
          },
          child: ExtendedImageGesturePageView.builder(
              controller: ExtendedPageController(
                initialPage: widget.currentIndex,
                pageSpacing: 20.0,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: widget.medias.length,
              itemBuilder: (context, index) {
                final media = widget.medias[index];
                if (media.type == MediaType.VIDEO) {
                  return ExtendedVideo(video: media);
                }
                return ExtendedPageImage(
                    image: media, slidePageKey: slidePageKey);
              }),
        ),
      ),
    );
  }
}

class ExtendedPageImage extends StatefulWidget {
  const ExtendedPageImage(
      {Key? key, required this.image, required this.slidePageKey})
      : super(key: key);

  final MediaEntity image;
  final GlobalKey<ExtendedImageSlidePageState> slidePageKey;

  @override
  State<StatefulWidget> createState() {
    return _ExtendedPageImageState();
  }
}

typedef DoubleClickAnimationListener = Function();

class _ExtendedPageImageState extends State<ExtendedPageImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];

  @override
  void initState() {
    super.initState();

    _doubleClickAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
  }

  @override
  void dispose() {
    _doubleClickAnimationController.dispose();
    super.dispose();
  }

  Widget _extendedImageBuilder(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ExtendedImage.network(
      widget.image.url,
      enableSlideOutPage: true,
      mode: ExtendedImageMode.gesture,
      fit: BoxFit.contain,
      initGestureConfigHandler: (state) {
        double? initialScale = 1.0;

        if (state.extendedImageInfo != null) {
          initialScale = initScale(
              size: size,
              initialScale: initialScale,
              imageSize: Size(state.extendedImageInfo!.image.width.toDouble(),
                  state.extendedImageInfo!.image.height.toDouble()));
        }
        return GestureConfig(
          inPageView: true,
          minScale: 1.0,
          initialScale: initialScale!,
          maxScale: max(initialScale, 2.0),
          animationMaxScale: max(initialScale, 5.0),
          initialAlignment: InitialAlignment.center,
          //you can cache gesture state even though page view page change.
          //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
          cacheGesture: false,
        );
      },
      onDoubleTap: (state) {
        ///you can use define pointerDownPosition as you can,
        ///default value is double tap pointer down postion.
        final Offset? pointerDownPosition = state.pointerDownPosition;
        final double? begin = state.gestureDetails!.totalScale;
        double end;

        //remove old
        _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);

        //stop pre
        _doubleClickAnimationController.stop();

        //reset to use
        _doubleClickAnimationController.reset();

        if (begin == doubleTapScales[0]) {
          end = doubleTapScales[1];
        } else {
          end = doubleTapScales[0];
        }

        _doubleClickAnimationListener = () {
          //print(_animation.value);
          state.handleDoubleTap(
              scale: _doubleClickAnimation!.value,
              doubleTapPosition: pointerDownPosition);
        };
        _doubleClickAnimation = _doubleClickAnimationController
            .drive(Tween<double>(begin: begin, end: end));

        _doubleClickAnimation!.addListener(_doubleClickAnimationListener);

        _doubleClickAnimationController.forward();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeroWidget(
        child: _extendedImageBuilder(context),
        tag: widget.image.url,
        slidePagekey: widget.slidePageKey);
  }
}

/// make hero better when slide out
class HeroWidget extends StatefulWidget {
  const HeroWidget({
    required this.child,
    required this.tag,
    required this.slidePagekey,
    this.slideType = SlideType.onlyImage,
  });
  final Widget child;
  final SlideType slideType;
  final Object tag;
  final GlobalKey<ExtendedImageSlidePageState> slidePagekey;
  @override
  _HeroWidgetState createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  RectTween? _rectTween;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      createRectTween: (Rect? begin, Rect? end) {
        _rectTween = RectTween(begin: begin, end: end);
        return _rectTween!;
      },
      // make hero better when slide out
      flightShuttleBuilder: (BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext) {
        // make hero more smoothly
        final Hero hero = (flightDirection == HeroFlightDirection.pop
            ? fromHeroContext.widget
            : toHeroContext.widget) as Hero;
        if (_rectTween == null) {
          return hero;
        }

        if (flightDirection == HeroFlightDirection.pop) {
          final bool fixTransform = widget.slideType == SlideType.onlyImage &&
              (widget.slidePagekey.currentState!.offset != Offset.zero ||
                  widget.slidePagekey.currentState!.scale != 1.0);

          final Widget toHeroWidget = (toHeroContext.widget as Hero).child;
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext buildContext, Widget? child) {
              Widget animatedBuilderChild = hero.child;

              // make hero more smoothly
              animatedBuilderChild = Stack(
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                children: <Widget>[
                  Opacity(
                    opacity: 1 - animation.value,
                    child: UnconstrainedBox(
                      child: SizedBox(
                        width: _rectTween!.begin!.width,
                        height: _rectTween!.begin!.height,
                        child: toHeroWidget,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: animation.value,
                    child: animatedBuilderChild,
                  )
                ],
              );

              // fix transform when slide out
              if (fixTransform) {
                final Tween<Offset> offsetTween = Tween<Offset>(
                    begin: Offset.zero,
                    end: widget.slidePagekey.currentState!.offset);

                final Tween<double> scaleTween = Tween<double>(
                    begin: 1.0, end: widget.slidePagekey.currentState!.scale);
                animatedBuilderChild = Transform.translate(
                  offset: offsetTween.evaluate(animation),
                  child: Transform.scale(
                    scale: scaleTween.evaluate(animation),
                    child: animatedBuilderChild,
                  ),
                );
              }

              return animatedBuilderChild;
            },
          );
        }
        return hero.child;
      },
      child: widget.child,
    );
  }
}

///
///  create by zmtzawqlp on 2020/1/31
///
double? initScale({
  required Size imageSize,
  required Size size,
  double? initialScale,
}) {
  final double n1 = imageSize.height / imageSize.width;
  final double n2 = size.height / size.width;
  if (n1 > n2) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    final Size destinationSize = fittedSizes.destination;
    return size.width / destinationSize.width;
  } else if (n1 / n2 < 1 / 4) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    final Size destinationSize = fittedSizes.destination;
    return size.height / destinationSize.height;
  }

  return initialScale;
}

/// Save network image to the photo library.
Future<bool> saveNetworkImageToPhoto(String url, {bool useCache = true}) async {
  if (kIsWeb) {
    return false;
  }
  final String title = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  final Uint8List? data = await getNetworkImageData(url, useCache: useCache);
  final AssetEntity? imageEntity = await PhotoManager.editor.saveImage(
    data!,
    title: title,
  );
  return imageEntity != null;
}
