import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/values/app_fonts.dart';

class VideoTipView extends StatelessWidget {
  final bool isGuiding;
  const VideoTipView({Key? key, this.isGuiding = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 59),
          isGuiding
              ? Text('Ready to introduce yourself?',
                  style: Theme.of(context).textTheme.subtitle1)
              : Container(width: 10),
          isGuiding ? SizedBox(height: 8) : SizedBox(),
          Text('Make a video and answer these questions:',
              style: isGuiding
                  ? Theme.of(context).textTheme.subtitle2
                  : textStyle(
                      color: Colors.white, fontSize: 14, type: TextType.bold)),
          SizedBox(height: 8),
          dotText(context, 'Who are you and where are you from?', isGuiding),
          dotText(context, 'What\’s your daily schedule look like?', isGuiding),
          dotText(
              context, 'What do you enjoy doing in your downtime?', isGuiding),
          dotText(
              context, 'How would you describe your personality?', isGuiding),
          dotText(context, 'What kind of relationship are you looking for?',
              isGuiding),
        ],
      ),
    ));
  }

  Widget dotText(BuildContext context, String text, bool isGuiding) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 7),
              child: isGuiding
                  ? Image.asset('assets/images/signin/login_video_tips.png')
                  : Image.asset('assets/images/signin/dot_tip_record.png')),
          SizedBox(width: 10),
          Container(
            width: Get.width - 54,
            child: Text(text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: isGuiding
                    ? Theme.of(context).textTheme.overline
                    : textStyle(
                        color: Colors.white,
                        fontSize: 15,
                        type: TextType.regular,
                      )),
          )
        ],
      ),
    );
  }
}
