import 'dart:ui';

import 'package:bonfire/bonfire.dart';

class EnemySpriteSheet {
  static late SpriteSheet littleMonster;
  static late SpriteSheet mediumMonster;
  static late SpriteSheet miniBoss;
  static late SpriteSheet boss;

  /// 初始化
  static Future load() async {
    littleMonster =
        await _create('enemy/little_monster/little_sprites.png', columns: 6);
    boss = await _create('enemy/boss/boss_sprites.png');
    mediumMonster = await _create('enemy/medium_monster/medium_sprites.png');
    miniBoss = await _create('enemy/mini_boss/mini_boss_sprites.png');
  }

  static Future<SpriteSheet> _create(String path,
      {int columns = 4, int rows = 4}) async {
    Image image = await Flame.images.load(path);
    return SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: columns,
      rows: rows,
    );
  }

  static SimpleDirectionAnimation animationBySpriteSheetTest(
      SpriteSheet spriteSheet) {
    return SimpleDirectionAnimation(
      idleLeft: Future.value(
        spriteSheet.createAnimation(row: 3, stepTime: 0.2),
      ),
      idleRight: Future.value(
        spriteSheet.createAnimation(row: 1, stepTime: 0.2),
      ),
      runLeft: Future.value(
        spriteSheet.createAnimation(row: 2, stepTime: 0.2),
      ),
      runRight: Future.value(
        spriteSheet.createAnimation(row: 0, stepTime: 0.2),
      ),
    );
  }

  static Future<SpriteAnimation> bossIdleRight() => SpriteAnimation.load(
        'enemy/boss/boss_idle.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(32, 36),
        ),
      );

  /// 敌人向下 攻击效果
  static Future<SpriteAnimation> enemyAttackEffectBottom() =>
      SpriteAnimation.load(
        'enemy/attack_effect_bottom.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  /// 敌人向上 攻击效果
  static Future<SpriteAnimation> enemyAttackEffectTop() => SpriteAnimation.load(
        'enemy/attack_effect_top.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  /// 敌人向左 攻击效果
  static Future<SpriteAnimation> enemyAttackEffectLeft() =>
      SpriteAnimation.load(
        'enemy/attack_effect_left.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  /// 敌人向右 攻击效果
  static Future<SpriteAnimation> enemyAttackEffectRight() =>
      SpriteAnimation.load(
        'enemy/attack_effect_right.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
}
