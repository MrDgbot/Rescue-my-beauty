import 'package:bonfire/bonfire.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/nobita/local_player.dart';

class DoorKey extends GameDecoration with Sensor {
  DoorKey(Vector2 position)
      : super.withSprite(
          sprite: Sprite.load('items/key_silver.png'),
          position: position,
          size: Vector2(GameUtils.sTileSize, GameUtils.sTileSize),
        );

  @override
  void onContact(GameComponent component) {
    if (component is LocalPlayer) {
      component.containKey = true;
      removeFromParent();
    }
  }
}
