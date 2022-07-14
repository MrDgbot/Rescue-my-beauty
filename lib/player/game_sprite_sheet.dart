import 'package:bonfire/bonfire.dart';

class GameSpriteSheet{
  static Future<SpriteAnimation> spikes() => SpriteAnimation.load(
    'items/spikes.png',
    SpriteAnimationData.sequenced(
      amount: 10,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );
}