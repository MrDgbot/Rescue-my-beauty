import 'package:bonfire/bonfire.dart';

class EnemySpriteSheet {
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

  /// 小怪兽 动画
  static SimpleDirectionAnimation littleMonsterAnimations() =>
      SimpleDirectionAnimation(
        idleLeft: SpriteAnimation.load(
          'enemy/little_monster/littleMonster_idle_left.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        idleRight: SpriteAnimation.load(
          'enemy/little_monster/littleMonster_idle.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        runLeft: SpriteAnimation.load(
          'enemy/little_monster/littleMonster_run_left.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        runRight: SpriteAnimation.load(
          'enemy/little_monster/littleMonster_run_right.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
      );

  /// 中型怪兽 动画
  // ignore: non_constant_identifier_names
  static SimpleDirectionAnimation MediumMonsterAnimations() => SimpleDirectionAnimation(
    idleLeft: SpriteAnimation.load(
      'enemy/medium_monster/mediumMonster_idle_left.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    idleRight: SpriteAnimation.load(
      'enemy/medium_monster/mediumMonster_idle.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    runLeft: SpriteAnimation.load(
      'enemy/medium_monster/mediumMonster_run_left.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    runRight: SpriteAnimation.load(
      'enemy/medium_monster/mediumMonster_run_right.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
  );

  /// 终极BOSS 动画
  static SimpleDirectionAnimation bossAnimations() => SimpleDirectionAnimation(
    idleLeft: SpriteAnimation.load(
      'enemy/boss/boss_idle_left.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(32, 36),
      ),
    ),
    idleRight: bossIdleRight(),
    runLeft: SpriteAnimation.load(
      'enemy/boss/boss_run_left.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(32, 36),
      ),
    ),
    runRight: SpriteAnimation.load(
      'enemy/boss/boss_run_right.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(32, 36),
      ),
    ),
  );

  static Future<SpriteAnimation> bossIdleRight() => SpriteAnimation.load(
    'enemy/boss/boss_idle.png',
    SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2(32, 36),
    ),
  );
}
