import 'package:bonfire/bonfire.dart';
import 'package:rescue_my_beauty/common/utils.dart';

class PotionLife extends GameDecoration with Sensor {
  final Vector2 initPosition;
  final double life;

  PotionLife(this.initPosition, {this.life = 30})
      : super.withSprite(
            sprite: Sprite.load('items/potion_red.png'),
            position: initPosition,
            size: Vector2(GameUtils.sTileSize, GameUtils.sTileSize));

  @override
  void onContact(GameComponent component) {
    if (component is Player) {
      gameRef.player?.addLife(life);
      removeFromParent();
    }
  }
}
