import 'package:heyya/app/core/extensions/DateTime+Ext.dart';
import 'package:intl/intl.dart';

abstract class MomentHelper {
  static final Map<String, String> _formatedTimesMap = {};

  static String getMomentFormatedTime(String momentId, String createTime) {
    String? v = _formatedTimesMap[momentId];
    if (v != null) {
      return v;
    }
    final dt = DateTime.tryParse(createTime);
    if (dt == null) {
      v = '';
    } else {
      final now = DateTime.now();
      if (now.isSameDay(dt)) {
        v = DateFormat('HH:mm a').format(dt);
      } else {
        v = DateFormat('MM-dd-yyyy HH:mm a').format(dt);
      }
    }
    _formatedTimesMap[momentId] = v;
    return v;
  }
}
