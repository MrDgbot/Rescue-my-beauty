import 'package:bonfire/bonfire.dart';
import '../player/game_sprite_sheet.dart';
import '../player/nobita/local_player.dart';

class Spikes extends GameDecoration with Sensor {
  final double damage;

  Spikes(Vector2 position, {this.damage = 60})
      : super.withAnimation(
            animation: GameSpriteSheet.spikes(),
            position: position,
            size: Vector2(tileSize, tileSize)) {
    setupSensorArea(
      intervalCheck: 100,
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
