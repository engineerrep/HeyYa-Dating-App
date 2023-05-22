import 'package:heyya/app/data/repository/heyya_list_repostitory.dart';
import 'package:heyya/app/modules/profile/list/heyya_list_ontroller.dart';

class VisitorsController extends HeyyaListController {
  @override
  void onReady() {
    super.onReady();
    getUserPageInfos(type: ApiType.visitorList, isRefresh: true);
  }
}
