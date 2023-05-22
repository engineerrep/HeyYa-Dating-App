import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/enum/report_type.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import '../controllers/report_controller.dart';

class ReportItemView extends GetView {
  final ReportType type;
  final Widget icon;
  ReportItemView({Key? key, required this.type, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
            height: 54,
            child: Column(children: [
              Expanded(
                  child: Row(children: [
                Text(type.toDistplay(),
                    style: textStyle(
                        type: TextType.regular,
                        color: ThemeColors.c272b00,
                        fontSize: 16)),
                Spacer(),
                GestureDetector(
                    child: Center(child: icon), onTap: _selectClick),
              ], mainAxisAlignment: MainAxisAlignment.center)),
              Divider(height: 1, color: ThemeColors.c272b00.withOpacity(0.2)),
            ])));
  }

  void _selectClick() {
    final _controller = Get.find<ReportController>();
    if (_controller.selectedItems.contains(type)) {
      _controller.selectedItems.remove(type);
    } else {
      _controller.selectedItems.clear();
      _controller.selectedItems.add(type);
    }
  }
}
