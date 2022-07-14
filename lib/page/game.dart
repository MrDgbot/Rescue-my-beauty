import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/decoration/boss.dart';
import 'package:rescue_my_beauty/decoration/light.dart';
import 'package:rescue_my_beauty/decoration/spikes.dart';
import 'package:rescue_my_beauty/player/nobita/local_player.dart';

@FFRoute(
  name: "rescue://gamepage",
  routeName: "GamePage",
)
class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with WidgetsBindingObserver
    implements GameListener {
  late GameController _controller;
  bool _showGameOver = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _controller = GameController()..addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BonfireTiledWidget(
        onReady: _startCameraMove,
        constructionMode: false,
        showCollisionArea: true,
        gameController: _controller,
        lightingColorGame: GameUtils.bgColor,
        background: BackgroundColorGame(Colors.black),
        player: LocalPlayer(
          1,
          "野比大雄",
          Vector2(4 * GameUtils.sTileSize, 4 * GameUtils.sTileSize),
        ),
        joystick: Joystick(
          keyboardConfig: KeyboardConfig(
            acceptedKeys: [
              LogicalKeyboardKey.space,
            ],
          ),
          directional: JoystickDirectional(),
          // actions: [
          //   JoystickAction(
          //     actionId: 1,
          //     color: Colors.deepOrange,
          //     margin: const EdgeInsets.all(65),
          //   )
          // ],
        ),
        map: TiledWorldMap('tiles/map.json',
            forceTileSize: Size(GameUtils.sTileSize, GameUtils.sTileSize),
            objectsBuilder: {
              'light': (p) => Light(p.position, p.size),
              'monster': (p) => Boss(p.position, p.size),
              'boss': (p) => Boss(p.position, p.size, zoom: 3),
              'spikes': (p) => Spikes(p.position),
            }),
        cameraConfig:
            CameraConfig(smoothCameraEnabled: true, smoothCameraSpeed: 2),
        progress: Container(
          color: Colors.black,
          child: const Center(
            child: Text(
              '载入中...',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        // initialActiveOverlays: const ['miniMap'],
        // overlayBuilderMap: {
        //   'miniMap': (context, game) => MiniMap(
        //         game: game,
        //         margin: const EdgeInsets.all(10),
        //         borderRadius: BorderRadius.circular(10),
        //         size: Vector2.all(min(constraints.maxHeight, constraints.maxWidth) / 4.3),
        //         border: Border.all(color: Colors.white.withOpacity(0.5)),
        //       ),
        // },
      ),
    );
  }

  /// 开局相机视角移动
  Future<void> _startCameraMove(BonfireGame game) async {
    if(!GameUtils.isStartCameraMove){
      return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      final enemy = game.decorations().firstWhere((e) => e is Boss);
      game.startScene(
        [
          CameraSceneAction.target(game.player, zoom: 0.3),
          CameraSceneAction.target(enemy, zoom: 0.3),
          DelaySceneAction(const Duration(milliseconds: 1000)),
          CameraSceneAction.target(game.player, zoom: 0.7),
          CameraSceneAction.target(game.player, zoom: 1),
        ],
      );
    });
  }

  void _showDialogGameOver() {
    setState(() {
      _showGameOver = true;
    });
    // Dialogs.showGameOver(
    //   context,
    //       () {
    //     Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (context) => Game()),
    //           (Route<dynamic> route) => false,
    //     );
    //   },
    // );
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    if (_controller.player != null && _controller.player?.isDead == true) {
      if (!_showGameOver) {
        _showGameOver = true;
        _showDialogGameOver();
      }
    }
  }
}
