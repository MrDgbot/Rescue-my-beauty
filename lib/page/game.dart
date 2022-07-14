import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescue_my_beauty/player/nobita/local_player.dart';

import '../decoration/light.dart';
import '../decoration/spikes.dart';

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
  static const assetsPath = 'tiles';
  late GameController _controller;
  bool showGameOver = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _controller = GameController()..addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final tileSize = max(constraints.maxHeight, constraints.maxWidth) / 10;

      return Material(
        color: Colors.transparent,
        child: BonfireTiledWidget(
          onReady: (game) async {
            // await Future.delayed(
            //   const Duration(milliseconds: 500),
            //   () {
            //     if (game.player != null) {
            //       game.startScene(
            //         [
            //           CameraSceneAction.target(game.player, zoom: 0.5),
            //           CameraSceneAction.position(game.size * 4.7, zoom: 0.5),
            //           DelaySceneAction(const Duration(milliseconds: 500)),
            //           CameraSceneAction.target(game.player, zoom: 1),
            //         ],
            //       );
            //     }
            //   },
            // );
          },
          constructionMode: false,
          showCollisionArea: false,
          gameController: _controller,
          lightingColorGame: Colors.black.withOpacity(0.4),
          background: BackgroundColorGame(Colors.black),
          player: LocalPlayer(1, "野比大雄", Vector2(4 * tileSize, 4 * tileSize)),
          joystick: Joystick(
            keyboardConfig: KeyboardConfig(
              acceptedKeys: [
                LogicalKeyboardKey.space,
              ],
            ),
            directional: JoystickDirectional(),
            actions: [
              JoystickAction(
                actionId: 1,
                color: Colors.deepOrange,
                margin: const EdgeInsets.all(65),
              )
            ],
          ),
          map: TiledWorldMap(
            '$assetsPath/map.json',
            forceTileSize: Size(tileSize, tileSize),
            objectsBuilder: {
              'light':(p)=>Light(p.position,p.size),
              'spikes': (p) => Spikes(p.position),
            }
          ),
          cameraConfig: CameraConfig(
            smoothCameraEnabled: true,
            smoothCameraSpeed: 2,
          ),
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
    });
  }

  void _showDialogGameOver() {
    setState(() {
      showGameOver = true;
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
      if (!showGameOver) {
        showGameOver = true;
        _showDialogGameOver();
      }
    }
  }
}
