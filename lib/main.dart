import 'dart:io';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescue_my_beauty/player/sprite_sheet_hero.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_route.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_routes.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }
  await SpriteSheetHero.load();
  /// 沉浸式状态栏
  if(!Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rescue my beauty',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'pixel',
      ),
      initialRoute: Routes.rescueHomepage,
      onGenerateRoute: (RouteSettings settings) {
        return onGenerateRoute(
          settings: settings,
          getRouteSettings: getRouteSettings,
        );
      },
    );
  }

  @override
  void dispose() {
    /// 结束恢复隐藏状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    /// 隐藏状态栏和底部导航栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  }
}
