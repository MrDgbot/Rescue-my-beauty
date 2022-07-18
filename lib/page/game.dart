import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescue_my_beauty/common/screen.dart';
import 'package:rescue_my_beauty/common/storage.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/decoration/chest.dart';
import 'package:rescue_my_beauty/decoration/door.dart';
import 'package:rescue_my_beauty/decoration/light.dart';
import 'package:rescue_my_beauty/decoration/potion_life.dart';
import 'package:rescue_my_beauty/decoration/spikes.dart';
import 'package:rescue_my_beauty/enemies/boss.dart';
import 'package:rescue_my_beauty/enemies/little_monster.dart';
import 'package:rescue_my_beauty/enemies/medium_monster.dart';
import 'package:rescue_my_beauty/enemies/mini_boss.dart';
import 'package:rescue_my_beauty/models/player_info.dart';
import 'package:rescue_my_beauty/npc/shizuka.dart';
import 'package:rescue_my_beauty/player/nobita/local_player.dart';
import 'package:rescue_my_beauty/player/sprite_sheet_hero.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_routes.dart';
import 'package:rescue_my_beauty/topvars.dart';
import 'package:rescue_my_beauty/widgets/dialogs.dart';
import 'package:rescue_my_beauty/widgets/interface_overlay.dart';

@FFRoute(
  name: "rescue://gamepage",
  routeName: "GamePage",
)
class GamePage extends StatefulWidget {
  final bool? isRestart;

  const GamePage({Key? key, this.isRestart = false}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with WidgetsBindingObserver
    implements GameListener {
  late GameController _controller;
  bool _showGameOver = false;
  late Vector2 _heroPosition;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _controller = GameController()..addListener(this);
    _loading();
    super.initState();
  }

  void _loading() {
    if (StorageUtil.getJSON('game') != null && widget.isRestart!) {
      final localData =
          PlayerInfo.fromJson(StorageUtil.getJSON('game')).loaction;
      _heroPosition = Vector2(localData.x, localData.y);
    } else {
      _heroPosition = Vector2(4 * GameUtils.sTileSize, 4 * GameUtils.sTileSize);
    }
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
          _heroPosition,
          SpriteSheetHero.hero5,
        ),
        joystick: Joystick(
          keyboardConfig: KeyboardConfig(
            acceptedKeys: [
              LogicalKeyboardKey.space,
            ],
          ),
          directional: JoystickDirectional(
            spriteBackgroundDirectional: Sprite.load('joystick/background.png'),
            spriteKnobDirectional: Sprite.load('joystick/knob.png'),
            size: 100,
            isFixed: false,
          ),
          actions: [
            JoystickAction(
              actionId: 0,
              sprite: Sprite.load('joystick/atack.png'),
              spritePressed: Sprite.load('joystick/atack_selected.png'),
              size: 80,
              margin: const EdgeInsets.only(bottom: 50, right: 50),
            ),
            JoystickAction(
              actionId: 1,
              sprite: Sprite.load('joystick/atack_range.png'),
              spritePressed: Sprite.load('joystick/atack_range_selected.png'),
              size: 50,
              margin: const EdgeInsets.only(bottom: 50, right: 160),
            )
          ],
        ),
        map: TiledWorldMap(
          'tiles/map.json',
          forceTileSize: Size(GameUtils.sTileSize, GameUtils.sTileSize),
          objectsBuilder: {
            'light': (p) => Light(p.position, p.size),
            'chest': (p) => Chest(p.position),
            'mini_boss': (p) => MiniBoss(p.position),
            'spikes': (p) => Spikes(p.position, randomDamage: true),
            'potion': (p) => PotionLife(p.position),
            'monster1': (p) => LittleMonster(p.position),
            'monster2': (p) => MediumMonster(p.position),
            'boss': (p) => Boss(p.position),
            'door': (p) => Door(p.position),
            'sk': (p) => Shizuka(p.position),
          },
        ),
        cameraConfig: CameraConfig(
          smoothCameraEnabled: true,
          moveOnlyMapArea: true,
          smoothCameraSpeed: 2,
        ),
        initialActiveOverlays: const ['barLife', 'miniMap'],
        overlayBuilderMap: {
          'barLife': (_, game) => InterfaceOverlay(
                gameController: _controller,
              ),
          'miniMap': (context, game) => MiniMap(
                game: game,
                margin: const EdgeInsets.all(10),
                borderRadius: BorderRadius.circular(10),
                size: Vector2.all(
                    min(Screen.screenHeight, Screen.screenWidth) / 4.4),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
        },
        progress: Container(
          color: Colors.black,
          child: const Center(
            child: Text(
              '载入中...',
              style: textStyle24B,
            ),
          ),
        ),
      ),
    );
  }

  /// 开局相机视角移动
  Future<void> _startCameraMove(BonfireGame game) async {
    if (!GameUtils.isStartCameraMove) {
      return;
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      final enemy = game.enemies().firstWhere((e) => e is Boss);
      game.startScene([
        CameraSceneAction.target(game.player, zoom: 0.3),
        CameraSceneAction.target(enemy, zoom: 0.3),
        DelaySceneAction(const Duration(milliseconds: 1000)),
        CameraSceneAction.target(game.player, zoom: 0.7),
        CameraSceneAction.target(game.player, zoom: 1),
      ]);
    });
  }

  void _showDialogGameOver() {
    setState(() {
      _showGameOver = true;
    });

    Dialogs.showGameOver(
      context,
      () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.rescueGamepage, (route) => false);
      },
    );
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
