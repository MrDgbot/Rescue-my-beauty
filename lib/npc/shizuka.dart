import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/sprite_sheet_hero.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_routes.dart';
import 'package:rescue_my_beauty/widgets/dialogs.dart';

class Shizuka extends GameDecoration with ObjectCollision {
  bool _showConversation = false;

  // final IntervalTick _timer = IntervalTick(1000);

  Shizuka(
    Vector2 position,
  ) : super.withAnimation(
          animation: Future.value(
            SpriteSheetHero.hero4.createAnimation(row: 0, stepTime: 0.1),
          ),
          position: position,
          size: Vector2(GameUtils.sTileSize * 1.2, GameUtils.sTileSize * 1.2),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(width, height),
            align: Vector2(0, 0),
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
          if (!_showConversation) {
            gameRef.player!.idle();
            _showConversation = true;
            _startConversation();
          }
        },
        radiusVision: (1 * GameUtils.sTileSize),
      );
    }
  }

  void _startConversation() {
    TalkDialog.show(gameRef.context, [
      Say(
        text: [const TextSpan(text: '大雄，你终于来了！')],
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [const TextSpan(text: '静香，对不起让你受苦了！')],
        personSayDirection: PersonSayDirection.LEFT,
      ),
    ], onFinish: () {
      Dialogs.showGameOver(
        context,
        () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.rescueGamepage, (route) => false);
        },
      );
    });
  }
}
