// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heyya/app/app.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/config.dart';
import 'app/flavors/build_config.dart';
import 'app/flavors/env_config.dart';
import 'app/flavors/environment.dart';

void main() async {
  await AppManager.initialApp();
  EnvConfig devConfig = EnvConfig(
    baseUrl: develop_base_url,
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );

  runApp(const App());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}
