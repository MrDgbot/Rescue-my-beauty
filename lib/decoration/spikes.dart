import 'package:bonfire/bonfire.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/game_sprite_sheet.dart';


class Spikes extends GameDecoration with Sensor {
  final double damage;

  Spikes(Vector2 position, {this.damage = 5})
      : super.withAnimation(
            animation: GameSpriteSheet.spikes(),
            position: position,
            size: Vector2(GameUtils.sTileSize, GameUtils.sTileSize)) {
    setupSensorArea(
      intervalCheck: 250,
    );
  }

  @override
  void onContact(GameComponent collision) {
    if (collision is Player) {
      if (animation?.currentIndex == (animation?.frames.length ?? 0) - 1 ||
          animation?.currentIndex == (animation?.frames.length ?? 0) - 2) {
        gameRef.player?.receiveDamage(AttackFromEnum.ENEMY, damage, 0);
      }
    }
  }

  @override
  int get priority => LayerPriority.getComponentPriority(1);
}
