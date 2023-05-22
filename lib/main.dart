// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heyya/app/app.dart';
import 'package:heyya/config.dart';
import 'app/core/utils/app_manager.dart';
import 'app/flavors/build_config.dart';
import 'app/flavors/env_config.dart';
import 'app/flavors/environment.dart';

void main() async {
  await AppManager.initialApp();

  EnvConfig prodConfig = EnvConfig(
    baseUrl: product_base_url,
    shouldCollectCrashLog: false,
  );

  BuildConfig.instantiate(
    envType: Environment.PRODUCTION,
    envConfig: prodConfig,
  );

  runApp(const App());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}
