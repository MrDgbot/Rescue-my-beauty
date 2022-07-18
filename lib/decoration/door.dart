import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/game_sprite_sheet.dart';
import 'package:rescue_my_beauty/player/nobita/local_player.dart';
import 'package:rescue_my_beauty/topvars.dart';

class Door extends GameDecoration with ObjectCollision {
  bool open = false;
  bool showDialog = false;

  Door(Vector2 position)
      : super.withSprite(
          sprite: Sprite.load('items/door_closed.png'),
          position:position,
          size: Vector2(GameUtils.sTileSize, GameUtils.sTileSize),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(width, height),
            align: Vector2(0, height * 0.75),
          ),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.player != null) {
      seeComponent(
        gameRef.player!,
        observed: (player) {
          if (!open) {
            LocalPlayer p = player as LocalPlayer;
            if (p.containKey == true) {
              open = true;
              gameRef.add(
                AnimatedObjectOnce(
                  animation: GameSpriteSheet.openTheDoor(),
                  position: position,
                  onFinish: () {
                    p.containKey = false;
                  },
                  size: Vector2.all(GameUtils.sTileSize),
                ),
              );
              Future.delayed(const Duration(milliseconds: 200), () {
                removeFromParent();
              });
            } else {
              if (!showDialog) {
                showDialog = true;
                _showIntroduction();
              }
            }
          }
        },
        notObserved: () {
          showDialog = false;
        },
        radiusVision: (2 * GameUtils.sTileSize),
      );
    }
  }

  void _showIntroduction() {
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            const TextSpan(
              text: '你还没有钥匙，需要打败Boss哦！(击败Boos后在附近找找吧)',
            )
          ],
          person: (gameRef.player as SimplePlayer?)
                  ?.animation
                  ?.idleRight
                  ?.asWidget() ??
              sizedBox,
          personSayDirection: PersonSayDirection.LEFT,
        )
      ],
    );
  }
}
