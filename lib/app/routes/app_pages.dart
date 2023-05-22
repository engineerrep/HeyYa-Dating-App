import 'package:get/get.dart';

import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/contact_info/bindings/contact_info_binding.dart';
import '../modules/contact_info/views/contact_info_view.dart';
import '../modules/conversation/bindings/conversation_binding.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_aboutme_view.dart';
import '../modules/edit_profile/views/edit_profile_avatar_view.dart';
import '../modules/edit_profile/views/edit_profile_gender_view.dart';
import '../modules/edit_profile/views/edit_profile_name_view.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/edit_video_avatar/bindings/edit_video_avatar_binding.dart';
import '../modules/edit_video_avatar/views/edit_video_avatar_view.dart';
import '../modules/feedback/bindings/feedback_binding.dart';
import '../modules/feedback/views/feedback_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/launch/bindings/launch_binding.dart';
import '../modules/launch/views/launch_view.dart';
import '../modules/moment/bindings/moment_binding.dart';
import '../modules/moment_post/bindings/moment_post_binding.dart';
import '../modules/moment_post/views/moment_post_view.dart';
import '../modules/pp_sa/bindings/pp_sa_binding.dart';
import '../modules/pp_sa/views/pp_sa_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/block_list_view.dart';
import '../modules/profile/views/likes_me_view.dart';
import '../modules/profile/views/matched_view.dart';
import '../modules/profile/views/my_likes_view.dart';
import '../modules/profile/views/visitor_view.dart';
import '../modules/report/bindings/report_binding.dart';
import '../modules/report/views/report_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/sign/bindings/sign_binding.dart';
import '../modules/sign/views/guiding_view.dart';
import '../modules/sign/views/sign_view.dart';
import '../modules/spark/bindings/spark_binding.dart';
import '../modules/tabbar/bindings/tabbar_binding.dart';
import '../modules/tabbar/views/tabbar_view.dart';
import '../modules/user_profile/bindings/user_profile_binding.dart';
import '../modules/user_profile/views/user_profile_view.dart';
import '../modules/verified_videos/bindings/verified_videos_binding.dart';
import '../modules/verified_videos/views/verified_videos_view.dart';
import '../modules/video/bindings/video_guiding_binding.dart';
import '../modules/video/bindings/video_player_binding.dart';
import '../modules/video/bindings/video_preview_binding.dart';
import '../modules/video/bindings/video_record_binding.dart';
import '../modules/video/views/video_guiding_view.dart';
import '../modules/video/views/video_player_view.dart';
import '../modules/video/views/video_preview_view.dart';
import '../modules/video/views/video_record_view.dart';
import '../modules/video_list/bindings/video_list_binding.dart';
import '../modules/video_list/views/video_list_view.dart';
import '../modules/video_topic/bindings/video_topic_binding.dart';
import '../modules/video_topic/bindings/video_topic_record_binding.dart';
import '../modules/video_topic/views/video_topic_record_view.dart';
import '../modules/video_topic/views/video_topic_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGN;

  // static const INITIAL = Routes.TABBAR;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGN,
      page: () => const SignView(),
      binding: SignBinding(),
    ),
    GetPage(
      name: _Paths.TABBAR,
      page: () => TabbarView(),
      binding: TabbarBinding(),
      bindings: [
        VideoListBinding(),
        SparkBinding(),
        MomentBinding(),
        ConversationBinding(),
        ProfileBinding(),
      ],
      // children: [
      //   GetPage(
      //     name: _Paths.SPARK,
      //     page: () => const SparkView(),
      //   ),
      //   GetPage(
      //     name: _Paths.MOMENT,
      //     page: () => const MomentView(),
      //   ),
      //   GetPage(
      //     name: _Paths.CONVERSATION,
      //     page: () => const ConversationView(),
      //   ),
      //   GetPage(
      //     name: _Paths.PROFILE,
      //     page: () => ProfileView(),
      //   ),
      // ]
    ),
    GetPage(
      name: _Paths.MYLIKES,
      page: () => MyLikesView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LIKESME,
      page: () => LikesMeView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MATCHED,
      page: () => MatchedView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.VISITORS,
      page: () => VisitorView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.BLOCK_LIST,
      page: () => BlockListView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.MOMENT_POST,
      page: () => MomentPostView(),
      binding: MomentPostBinding(),
    ),
    GetPage(
      name: _Paths.GUIDING,
      page: () => const GuidingView(),
      // binding: SignBinding(),
    ),
    GetPage(
      name: _Paths.FEEDBACK,
      page: () => const FeedbackView(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_GUIDING,
      page: () => const VideoGuidingView(),
      binding: VideoGuidingBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_RECORD,
      page: () => const VideoRecordView(),
      binding: VideoRecordBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_NAME,
      page: () => EditProfileNameView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_AVATAR,
      page: () => EditProfileAvatarView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_GENDER,
      page: () => EditProfileGenderView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_ABOUTME,
      page: () => EditProfileAboutmeView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.PP_SA,
      page: () => PpSaView(),
      binding: PpSaBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_PREVIEW,
      page: () => const VideoPreviewView(),
      binding: VideoPreviewBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_PLAYER,
      page: () => const HeyVideoPlayerView(),
      binding: HeyVideoPlayerBinding(),
    ),
    GetPage(
      name: _Paths.LAUNCH,
      page: () => const LaunchView(),
      binding: LaunchBinding(),
    ),
    GetPage(
      name: _Paths.USER_PROFILE,
      page: () => const UserProfileView(),
      binding: UserProfileBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.VERIFIED_VIDEOS,
      page: () => const VerifiedVideosView(),
      binding: VerifiedVideosBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_VIDEO_AVATAR,
      page: () => const EditVideoAvatarView(),
      binding: EditVideoAvatarBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_LIST,
      page: () => const VideoListView(),
      binding: VideoListBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_TOPIC,
      page: () => const VideoTopicView(),
      binding: VideoTopicBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_TOPIC_RECORD,
      page: () => const VideoTopicRecordView(),
      binding: VideoTopicRecordBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_INFO,
      page: () => const ContactInfoView(),
      binding: ContactInfoBinding(),
    ),
  ];
}
