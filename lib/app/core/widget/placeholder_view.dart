import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/custom_button.dart';

class PlaceholderView extends StatelessWidget {
  final String asset;
  final String title;
  final String content;
  final String? actionTitle;
  final VoidCallback? actionCallback;
  final bool showAction;

  static Widget serverErrorPlaceholder({VoidCallback? callback}) {
    String asset = Assets.errorImage;
    String title = "";
    String content = "The server went something wrong.";
    String actionTitle = "Refresh";
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      actionCallback: callback,
      showAction: false,
    );
  }

  static Widget networkErrorPlaceholder({VoidCallback? callback}) {
    String asset = Assets.networkImage;
    String title = "";
    String content = "Please check your network connection.";
    String actionTitle = "Refresh";
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      actionCallback: callback,
      showAction: false,
    );
  }

  static Widget visitorPlaceholder({VoidCallback? callback}) {
    String asset = Assets.iconNoMatches;
    String title = "No visitors yet.";
    String content = "";
    String actionTitle = "Go to Chat";
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      actionCallback: callback,
    );
  }

  static Widget matchedPlaceholder({VoidCallback? callback}) {
    String asset = Assets.iconNoMatches;
    String title = "No matches yet.";
    String content = "";
    String actionTitle = "Go to Chat";
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      actionCallback: callback,
    );
  }

  static Widget likesmePlaceholder({VoidCallback? callback}) {
    String asset = Assets.iconNoLikeme;
    String title = "Nobody liked you yet.";
    String content = "";
    String actionTitle = "Go to Chat";
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      actionCallback: callback,
    );
  }

  static Widget mylikesPlaceholder({VoidCallback? callback}) {
    String asset = Assets.iconNoMylike;
    String title = "You haven’t liked anyone yet.";
    String content = "";
    String actionTitle = "Go to Chat";
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      actionCallback: callback,
    );
  }

  static Widget conversationPlaceholder({VoidCallback? callback}) {
    String asset = Assets.messagesImage;
    String title = "No messages yet.";
    String content = "";
    String actionTitle = "Go to Chat";
    bool showAction = true;
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      showAction: showAction,
      actionCallback: callback,
    );
  }

  static Widget momentPlaceholder({VoidCallback? callback}) {
    String asset = Assets.momentImage;
    String title = "No moments yet.";
    String content = "Go post the first moment";
    String actionTitle = "POST";
    bool showAction = true;
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      actionCallback: callback,
      showAction: showAction,
    );
  }

  static Widget sparkPlaceholder({VoidCallback? callback}) {
    String asset = Assets.sparkImage;
    String title = "";
    String content = "No users for now.";
    String actionTitle = "Refresh";
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      actionCallback: callback,
    );
  }

  static Widget blocklistPlaceholder({VoidCallback? callback}) {
    String asset = Assets.momentImage;
    String title = "";
    String content = "You haven’t blocked anyone yet.";
    String? actionTitle;
    bool showAction = false;
    return PlaceholderView(
      asset: asset,
      title: title,
      content: content,
      actionTitle: actionTitle,
      actionCallback: callback,
      showAction: showAction,
    );
  }

  PlaceholderView(
      {super.key,
      required this.asset,
      required this.title,
      required this.content,
      this.actionTitle,
      this.actionCallback,
      this.showAction = true});

  @override
  Widget build(BuildContext context) {
    final List<Widget> lists = [
      Insets.top(margin: Get.height * 0.11),
      ExtendedImage.asset(asset),
      Text(
        title,
        textAlign: TextAlign.center,
        style: textStyle(
            type: TextType.bold, color: ThemeColors.c272b00, fontSize: 30),
      ),
      Insets.top(margin: 5),
      Text(
        content,
        textAlign: TextAlign.center,
        style: textStyle(
            type: TextType.regular, color: ThemeColors.c7f8a87, fontSize: 20),
      ),
    ];

    if (showAction && actionTitle != null) {
      lists.add(Insets.top(margin: 30));
      lists.add(CustomButton(
        titleForNormal: actionTitle!,
        state: CustomButtonState.selected,
        onTap: () {
          if (actionCallback != null) {
            actionCallback!();
          }
        },
      ));
    }
    return SafeArea(
        child: Container(
            padding: Insets.insetsWith(type: InsetsType.leftRight),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: lists,
              ),
            )));
  }
}
