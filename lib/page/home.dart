import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/sounds.dart';
import 'package:rescue_my_beauty/player/sprite_sheet_hero.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_routes.dart';

@FFRoute(
  name: "rescue://homepage",
  routeName: "HomePage",
)
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showSplash = true;
  int currentPosition = 0;
  late async.Timer _timer;
  late List<SpriteSheet> sprites;

  @override
  void initState() {
    super.initState();
    sprites = [
      SpriteSheetHero.hero1,
      SpriteSheetHero.hero2,
      SpriteSheetHero.hero3,
      SpriteSheetHero.hero4,
    ];
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Sounds.playBackgroundSound();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: showSplash ? buildSplash() : _buildHome(context),
    );
  }

  _doPlay(BuildContext context) {
    Navigator.of(context).popAndPushNamed(Routes.rescueGamepage);
  }

  Widget _buildHome(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      child: Wrap(
        spacing: 20,
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "のび太が静香を救う",
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            "大雄之拯救静香",
            style: Theme.of(context).textTheme.headline4,
          ),
          if (sprites.isNotEmpty) buildPlayerAnimation(),
          ElevatedButton(
            onPressed: () {
              _doPlay(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "开始",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 开局闪屏页
  Widget buildSplash() {
    return FlameSplashScreen(
      theme: FlameSplashTheme.dark,
      onFinish: (BuildContext context) {
        setState(() {
          showSplash = false;
        });
        startTimer();
      },
    );
  }

  /// 构建中间人物行走
  Widget buildPlayerAnimation() {
    return SizedBox(
      width: 100,
      height: 100,
      child: SpriteAnimationWidget(
        animation: sprites[currentPosition].createAnimation(
          row: 2,
          stepTime: 0.15,
        ),
        anchor: Anchor.center,
      ),
    );
  }

  /// 切换下一个人物的计时器。
  /// 每 2 秒更改一次
  void startTimer() {
    _timer = async.Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentPosition++;
        if (currentPosition > sprites.length - 1) {
          currentPosition = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    // Sounds.stopBackgroundSound();
    _timer.cancel();
    super.dispose();
  }
}
