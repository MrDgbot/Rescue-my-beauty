import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/game_sprite_sheet.dart';

class Spikes extends GameDecoration with Sensor {
  final double damage;
  final bool randomDamage;

  Spikes(Vector2 position, {this.damage = 5, this.randomDamage = false})
      : super.withAnimation(
            animation: GameSpriteSheet.spikes(),
            position: position,
            size: Vector2(GameUtils.sTileSize, GameUtils.sTileSize)) {
    setupSensorArea(
      intervalCheck: 80,
    );
  }

  @override
  void onContact(GameComponent component) {
    if (component is Player) {
      if (animation?.currentIndex == (animation?.frames.length ?? 0) - 1 ||
          animation?.currentIndex == (animation?.frames.length ?? 0) - 2) {
        final double mDamage =
            randomDamage ? damage + Random().nextDouble() * 5 : damage;
        gameRef.player?.receiveDamage(AttackFromEnum.ENEMY, mDamage, 0);
      }
    }
  }

  @override
  int get priority => LayerPriority.getComponentPriority(1);
}
