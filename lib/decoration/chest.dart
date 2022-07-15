import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/decoration/potion_life.dart';
import 'package:rescue_my_beauty/player/game_sprite_sheet.dart';

class Chest extends GameDecoration with TapGesture {
  bool _observedPlayer = false;

  late TextPaint _textConfig;

  Chest(Vector2 position)
      : super.withAnimation(
            animation: GameSpriteSheet.chestAnimated(),
            position: position,
            size: Vector2(GameUtils.sTileSize, GameUtils.sTileSize)) {
    _textConfig = TextPaint(
        style: TextStyle(
      color: const Color(0xFFFFFFFF),
      fontSize: width / 5,
    ));
  }

  @override
  void update(double dt) {
    if (gameRef.player != null) {
      seeComponent(
        gameRef.player!,
        observed: (player) {
          if (!_observedPlayer) {
            _observedPlayer = true;
            _showEmote();
          }
        },
        notObserved: () {
          _observedPlayer = false;
        },
        radiusVision: GameUtils.sTileSize,
      );
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_observedPlayer) {
      _textConfig.render(
        canvas,
        'Touch me !!',
        Vector2(x - width / 1.5, center.y - (height + 5)),
      );
    }
  }

  @override
  void onTap() {
    if (_observedPlayer) {
      _addPotions();
      removeFromParent();
    }
  }

  @override
  void onTapCancel() {}

  @override
  void onTapDown(int pointer, Vector2 position) {}

  @override
  void onTapUp(int pointer, Vector2 position) {}

  void _addPotions() {
    gameRef.add(
      PotionLife(
        Vector2(
          position.translate(width * 2, 0).x,
          position.y - height * 2,
        ),
      ),
    );
  }

  void _showEmote() {
    gameRef.add(
      AnimatedFollowerObject(
        animation: GameSpriteSheet.emote(),
        target: this,
        size: size,
        positionFromTarget: size / -2,
      ),
    );
  }

  // void _addSmokeExplosion(Vector2 translate) {
  //   gameRef.add(
  //     AnimatedObjectOnce(
  //       animation: CommonSpriteSheet.smokeExplosion,
  //       position: position,
  //       size: Vector2.all(GameUtils.tileSize),
  //     ),
  //   );
  // }
}
