import 'package:get/get.dart';
import 'package:heyya/app/data/model/user_entity.dart';

class ReportBlockState extends GetxController {
  //举报用户
  String? willReportUserId;
  var didReportUserId = "".obs;

  //拉黑用户
  String? willBlockUserId;
  var didBlockUserId = "".obs;

  //删除moment
  String? willDeleteMomentId;
  var didDeleteMomentId = "".obs;

  //useprofile unlike/like用户
  String? willCreateRelationWithUserId;
  var didCreateRelationWithUserId = "".obs;

  void didFinishCreateRelation() {
    var uid = willCreateRelationWithUserId;
    if (uid != null) {
      didCreateRelationWithUserId.value = uid;
      willCreateRelationWithUserId = null;
    }
  }

  void didFinishReport() {
    var uid = willReportUserId;
    if (uid != null) {
      didReportUserId.value = uid;
      willReportUserId = null;
    }
  }

  void didFinishBlock() {
    var uid = willBlockUserId;
    if (uid != null) {
      didBlockUserId.value = uid;
      willBlockUserId = null;
    }
  }

  void didDeleleMoment() {
    var id = willDeleteMomentId;
    if (id != null) {
      didDeleteMomentId.value = id;
      willDeleteMomentId = null;
    }
  }
}
