import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/sounds.dart';
import 'package:rescue_my_beauty/common/storage.dart';
import 'package:rescue_my_beauty/page/game.dart';
import 'package:rescue_my_beauty/player/sprite_sheet_hero.dart';

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
  bool _showSplash = !StorageUtil.getBool('isSplash');
  int _currentPosition = 0;
  late async.Timer _timer;
  late List<SpriteSheet> sprites;
  final bool _hasLocalData = StorageUtil.containsKey('game');

  @override
  void initState() {
    super.initState();
    sprites = [
      SpriteSheetHero.hero1,
      SpriteSheetHero.hero2,
      SpriteSheetHero.hero3,
      SpriteSheetHero.hero4,
    ];
    startTimer();
    if (!kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Sounds.playBackgroundSound();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _showSplash ? buildSplash() : _buildHome(context),
    );
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
          Wrap(
            spacing: 20,
            children: [
              ElevatedButton(
                onPressed: () {
                  _doPlay(context, isRestart: false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _hasLocalData ? "重新开始" : "开始",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              if (_hasLocalData)
                ElevatedButton(
                  onPressed: () {
                    _doPlay(context, isRestart: true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "继续游戏",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// 开始游戏
  _doPlay(BuildContext context, {bool? isRestart}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamePage(
          isRestart: isRestart ?? false,
        ),
      ),
    );
  }

  /// 开局闪屏页
  Widget buildSplash() {
    return FlameSplashScreen(
      theme: FlameSplashTheme.dark,
      onFinish: (BuildContext context) async {
        StorageUtil.setBool('isSplash', true).whenComplete(
          () => setState(() {
            _showSplash = false;
          }),
        );
        // startTimer();
      },
    );
  }

  /// 构建中间人物行走
  Widget buildPlayerAnimation() {
    return SizedBox(
      width: 100,
      height: 100,
      child: SpriteAnimationWidget(
        animation: sprites[_currentPosition].createAnimation(
          row: 2,
          stepTime: 0.2,
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
        _currentPosition++;
        if (_currentPosition > sprites.length - 1) {
          _currentPosition = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    Sounds.stopBackgroundSound();
    _timer.cancel();
    super.dispose();
  }
}
