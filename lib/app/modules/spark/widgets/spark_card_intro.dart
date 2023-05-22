import 'package:align_positioned/align_positioned.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/values/app_colors.dart';

class SparkCardIntro extends StatelessWidget {
  const SparkCardIntro({
    Key? key,
    required this.name,
    required this.selfIntro,
  }) : super(key: key);

  final String name;
  final String selfIntro;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // 343.0 / 233.0
      const whRatio = 1.47;
      return IgnorePointer(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxWidth / whRatio,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                  child: ExtendedImage.asset(
                Assets.sparkMask,
                fit: BoxFit.fitWidth,
              )),
              AlignPositioned.expand(
                dy: 7,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: ThemeColors.cddef00, fontSize: 26.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        selfIntro,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      height: 130,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
