import 'package:heyya/app/data/repository/heyya_list_repostitory.dart';
import 'package:heyya/app/modules/profile/list/heyya_list_ontroller.dart';

class MatchedController extends HeyyaListController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    getUserPageInfos(type: ApiType.matchList, isRefresh: true);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
