import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:heyya/app/core/utils/file_cache.dart';
import 'package:heyya/app/core/values/app_fonts.dart';

import 'bindings/initial_binding.dart';
import 'core/values/app_colors.dart';

import 'routes/app_pages.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<App> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    EMCache.shared.initialization();
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return GetMaterialApp(
      // title: _envConfig.appName,
      title: "Heyya",
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      supportedLocales: _getSupportedLocal(),
      builder: (context, child) {
        child = botToastBuilder(context, child);
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
          primaryColor: AppColors.colorPrimary,
          fontFamily: 'SinhalaMN',
          textTheme: TextTheme(
            // 22 bold
            headline2: textStyle(color: ThemeColors.c1f2320, fontSize: 22, type: TextType.bold),
            // 20 bold
            headline3: textStyle(color: ThemeColors.c1f2320, fontSize: 20, type: TextType.bold),
            // 18 bold
            headline4: textStyle(color: ThemeColors.c1f2320, fontSize: 18, type: TextType.bold),

            // 20 normal
            headline6: textStyle(color: ThemeColors.c1f2320, fontSize: 20, type: TextType.regular),

            // 16 bold
            subtitle1: textStyle(color: ThemeColors.c272b00, fontSize: 16, type: TextType.bold),
            subtitle2: textStyle(color: ThemeColors.c272b00, fontSize: 14, type: TextType.bold),

            // 16 normal
            bodyText1: textStyle(color: ThemeColors.c272b00, fontSize: 16, type: TextType.regular),

            // 16 normal
            bodyText2: textStyle(color: ThemeColors.c7f8a87, fontSize: 16, type: TextType.regular),

            // 14 normal
            overline: textStyle(
              color: ThemeColors.c272b00,
              fontSize: 14,
              type: TextType.regular,
            ),

            //12 normal
            caption: textStyle(color: ThemeColors.c7f8a87, fontSize: 12, type: TextType.regular),
          )),
      debugShowCheckedModeBanner: false,
    );
  }

  List<Locale> _getSupportedLocal() {
    return [
      const Locale('en', ''),
      const Locale('bn', ''),
    ];
  }
}
