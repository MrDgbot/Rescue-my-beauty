import 'package:bonfire/bonfire.dart';

class GameSpriteSheet {
  static Future<SpriteAnimation> spikes() => SpriteAnimation.load(
        'items/spikes.png',
        SpriteAnimationData.sequenced(
          amount: 10,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
  static Future<SpriteAnimation> chestAnimated() => SpriteAnimation.load(
        'items/chest_spriteSheet.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
  static Future<SpriteAnimation> emote() => SpriteAnimation.load(
        'emotes/emote_exclamacao.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ),
      );

  /// 敌人死亡 动画效果
  static Future<SpriteAnimation> smokeExplosion() => SpriteAnimation.load(
        'enemy/smoke_explosion.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  /// Boss死亡 爆炸效果
  static Future<SpriteAnimation> explosion() => SpriteAnimation.load(
        'explosion.png',
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ),
      );

  /// 火球 右 动画
  static Future<SpriteAnimation> fireBallAttackRight() => SpriteAnimation.load(
        'enemy/fireball_right.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(23, 23),
        ),
      );

  /// 火球 左 动画
  static Future<SpriteAnimation> fireBallAttackLeft() => SpriteAnimation.load(
        'enemy/fireball_left.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(23, 23),
        ),
      );

  /// 火球 上 动画
  static Future<SpriteAnimation> fireBallAttackTop() => SpriteAnimation.load(
        'enemy/fireball_top.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(23, 23),
        ),
      );

  /// 火球 下 动画
  static Future<SpriteAnimation> fireBallAttackBottom() => SpriteAnimation.load(
        'enemy/fireball_bottom.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(23, 23),
        ),
      );

  /// 火球 爆炸 动画
  static Future<SpriteAnimation> fireBallExplosion() => SpriteAnimation.load(
        'enemy/explosion_fire.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ),
      );
}
