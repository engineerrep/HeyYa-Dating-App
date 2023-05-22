import 'package:get/get.dart';

import '../modules/report/models/report_block_state.dart';

//Repository do not need to use Get.put
class RepositoryBindings implements Bindings {
  @override
  void dependencies() {
    //直接创建对象
    //是否有必要全局binding？
    //Get.lazyPut<UserRepository>(() => UserRepository());
    //Get.lazyPut<MomentRepository>(() => MomentRepository());
    //Get.lazyPut<MediaRepository>(() => MediaRepository());
  }
}
