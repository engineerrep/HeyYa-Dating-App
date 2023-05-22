import 'package:get/get.dart';
import 'package:heyya/app/core/extensions/UserEntity+Ext.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/core/utils/get_bottom_alert.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/local/Storage/storage.dart';
import 'package:heyya/app/data/model/account_entity.dart';
import 'package:heyya/app/data/model/relation_num_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/repository/user_repository.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:heyya/app/routes/app_pages.dart';

class Session {
  static Session shard() {
    return _shared;
  }

  static Session _shared = Session();

  Rx<AccountEntity>? account;
  Rx<UserEntity>? user;
  Rx<RelationNumEntity>? relation;

  static AccountEntity? getAccount() {
    if (_shared.account != null) {
      return _shared.account?.value;
    } else {
      final entity = Get.find<HeyStorage>().getAccount();
      if (entity != null) {
        _shared.account = Rx(entity);
      }
      return _shared.account?.value;
    }
  }

  static updateAccount(AccountEntity entity) {
    if (_shared.account == null) {
      _shared.account = Rx(entity);
    } else {
      _shared.account?.value = entity;
    }
    Get.find<HeyStorage>().saveAccount(entity);
  }

  static UserEntity? getUser() {
    if (_shared.user != null) {
      return _shared.user?.value;
    } else {
      final entity = Get.find<HeyStorage>().getUser();
      if (entity != null) {
        _shared.user = Rx(entity);
      }
      return _shared.user?.value;
    }
  }

  static updateUser(UserEntity entity) {
    if (_shared.user == null) {
      _shared.user = Rx(entity);
    } else {
      _shared.user?.value = entity;
    }
    Get.find<HeyStorage>().saveUser(entity);
  }

  static saveUser(UserEntity entity) {
    _shared.user = Rx(entity);
    Get.find<HeyStorage>().saveUser(entity);
  }

  static RelationNumEntity? getRelation() {
    if (_shared.relation != null) {
      return _shared.relation?.value;
    } else {
      final relation = Get.find<HeyStorage>().getRelation();
      if (relation != null) {
        _shared.relation = Rx(relation);
      }
      return _shared.relation?.value;
    }
  }

  updateRelation(RelationNumEntity entity) {
    if (user == null) {
      relation = Rx(entity);
    } else {
      relation?.value = entity;
    }
    Get.find<HeyStorage>().saveRelation(entity);
  }
}

enum Infomation {
  profile,
  name,
  avatar,
  gender,
  aboutme,
  video,
}

typedef CheckProfileCallback = dynamic Function(
    List<dynamic>? positionalArguments,
    [Map<Symbol, dynamic>? namedArguments]);

extension UserManager on Session {
  static Future<void> updateUserProfile({bool isShowLoading = false}) async {
    UserEntity user;
    if (isShowLoading) {
      var cancelLoading = showLoading();
      user = await UserRepository().getUserProfile();
      cancelLoading();
    } else {
      user = await UserRepository().getUserProfile();
    }
    Session.saveUser(user);
  }
}

extension UserProfile on Session {
  static void checkVideo(Function fn, List<dynamic>? positionalArguments,
      [Map<Symbol, dynamic>? namedArguments]) {
    if (complete(infomation: Infomation.video, needed: true)) {
      return;
    }
    Function.apply(fn, positionalArguments, namedArguments);
  }

  static void checkProfile(Function fn, List<dynamic>? positionalArguments,
      [Map<Symbol, dynamic>? namedArguments]) {
    if (completeProfileIfNeeded(needed: true)) {
      return;
    }
    Function.apply(fn, positionalArguments, namedArguments);
  }

  static editProfileComplete() {
    if (!UserProfile.completeProfileIfNeeded(needed: true, showAlert: false)) {
      AppManager.initialLogin();
      AppManager.switchToTabbarPage();
    }
  }

  static bool completeProfileIfNeeded(
      {required bool needed, bool showAlert = true}) {
    return complete(
        infomation: Infomation.profile, needed: needed, showAlert: showAlert);
  }

  static bool completeVideoIfNeeded(bool needed) {
    return complete(infomation: Infomation.video, needed: needed);
  }

  static toNextPage({required Infomation infomation, bool showAlert = true}) {
    switch (infomation) {
      case Infomation.name:
        Get.toNamed(Routes.EDIT_PROFILE_NAME);
        break;
      case Infomation.gender:
        Get.toNamed(Routes.EDIT_PROFILE_GENDER);
        break;
      case Infomation.avatar:
        Get.toNamed(Routes.EDIT_PROFILE_AVATAR);
        break;
      case Infomation.aboutme:
        Get.toNamed(Routes.EDIT_PROFILE_ABOUTME);
        break;
      case Infomation.video:
        GetBottomAlert.showCompleteVideoAlert(doneCallback: () {
          Get.back();
          Get.toNamed(Routes.VIDEO_GUIDING,
              arguments: VideoPreviewModel(previewType: VideoPreviewType.sign));
        }, cancelCallback: () {
          Get.back();
        });
        break;
      case Infomation.profile:
        if (showAlert) {
          GetBottomAlert.showCompleteProfileAlert(doneCallback: () {
            Get.back();
            if (complete(infomation: Infomation.name, needed: true)) {
            } else if (complete(infomation: Infomation.avatar, needed: true)) {
            } else if (complete(infomation: Infomation.gender, needed: true)) {
            } else if (complete(
                infomation: Infomation.aboutme, needed: true)) {}
          }, cancelCallback: () {
            Get.back();
          });
        } else {
          if (complete(infomation: Infomation.name, needed: true)) {
          } else if (complete(infomation: Infomation.avatar, needed: true)) {
          } else if (complete(infomation: Infomation.gender, needed: true)) {
          } else if (complete(infomation: Infomation.aboutme, needed: true)) {}
        }
        break;
    }
  }

  static bool complete(
      {required Infomation infomation,
      required bool needed,
      bool showAlert = true}) {
    switch (infomation) {
      case Infomation.profile:
        final confition =
            complete(infomation: Infomation.name, needed: false) ||
                complete(infomation: Infomation.avatar, needed: false) ||
                complete(infomation: Infomation.gender, needed: false) ||
                complete(infomation: Infomation.aboutme, needed: false);
        if (confition && needed) {
          toNextPage(infomation: Infomation.profile, showAlert: showAlert);
        }
        return confition;
      case Infomation.name:
        final value = Session.getUser()?.nickname ?? "";
        final confition = (value.length == 0);
        if (confition && needed) {
          toNextPage(infomation: Infomation.name);
        }
        return confition;
      case Infomation.gender:
        final value = Session.getUser()?.sex ?? "";
        final confition = (value.length == 0);
        if (confition && needed) {
          toNextPage(infomation: Infomation.gender);
        }
        return confition;
      case Infomation.avatar:
        final value = Session.getUser()?.avatar ?? "";
        final confition = (value.length == 0);
        if (confition && needed) {
          toNextPage(infomation: Infomation.avatar);
        }
        return confition;
      case Infomation.aboutme:
        final value = Session.getUser()?.aboutMe ?? "";
        final confition = (value.length == 0);
        if (confition && needed) {
          toNextPage(infomation: Infomation.aboutme);
        }
        return confition;
      case Infomation.video:
        final user = Session.getUser()!;
        final confition = !user.hasMainVideo();
        if (confition && needed) {
          toNextPage(infomation: Infomation.video);
        }
        return confition;
    }
  }
}
