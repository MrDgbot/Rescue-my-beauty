import 'dart:io';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:rescue_my_beauty/common/sounds.dart';
import 'package:rescue_my_beauty/common/storage.dart';
import 'package:rescue_my_beauty/player/enemy_sprite_sheet.dart';
import 'package:rescue_my_beauty/player/nobita/local_player_controller.dart';
import 'package:rescue_my_beauty/player/sprite_sheet_hero.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_route.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_routes.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

Future _initDependencies() async {
  if (!kIsWeb) {
    /// 设置横屏
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();

    /// 沉浸式状态栏
    if (!Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    }
  }
  await Sounds.initialize();
  await SpriteSheetHero.load();
  await EnemySpriteSheet.load();
  await StorageUtil.init();
  BonfireInjector().put((i) => LocalPlayerController());
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    /// 隐藏状态栏和底部导航栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rescue my beauty',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'cn',
      ),
      builder: FlutterSmartDialog.init(),
      initialRoute: Routes.rescueHomepage,
      navigatorObservers: [FlutterSmartDialog.observer],
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
}
