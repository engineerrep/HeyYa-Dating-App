import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heyya/app/core/values/app_fonts.dart';

//Default appbar customized with the design of our app
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String titleText;
  final List<Widget>? actions;
  final bool isBackButtonEnabled;
  final Color titleColor;
  final Color backgroundColor;
  final Color iconThemeColor;
  final Widget? leading;
  CustomAppBar({
    Key? key,
    required this.titleText,
    this.leading,
    this.actions,
    this.isBackButtonEnabled = true,
    this.backgroundColor = Colors.transparent,
    this.titleColor = Colors.black,
    this.iconThemeColor = Colors.black,
  }) : super(key: key);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: isBackButtonEnabled,
      actions: actions,
      iconTheme: IconThemeData(color: iconThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: leading,
      title: Text(
        titleText,
        style: textStyle(type: TextType.bold, fontSize: 20, color: titleColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
