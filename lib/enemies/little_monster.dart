import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/enemy_sprite_sheet.dart';
import 'package:rescue_my_beauty/player/game_sprite_sheet.dart';

class LittleMonster extends SimpleEnemy with ObjectCollision {
  final Vector2 initPosition;
  double attack = 5; // 攻击

  LittleMonster(this.initPosition)
      : super(
          animation: EnemySpriteSheet.animationBySpriteSheetTest(
              EnemySpriteSheet.littleMonster),
          position: initPosition,
          size: Vector2.all((GameUtils.sTileSize) * 0.8),
          speed: (GameUtils.sTileSize) / 0.4,
          life: 80,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(
              GameUtils.getSizeByTileSize(10),
              GameUtils.getSizeByTileSize(10),
            ),
            align: Vector2(
                GameUtils.getSizeByTileSize(3), GameUtils.getSizeByTileSize(4)),
          ),
        ],
      ),
    );
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    if (component is TileWithCollision) {
      final Vector2 position = component.position - initPosition;
      if (max(position.x, position.y).abs() < GameUtils.sTileSize / 1.6) {
        die();
      }
    }

    return super.onCollision(component, active);
  }

  @override
  void render(Canvas canvas) {
    drawDefaultLifeBar(
      canvas,
      borderRadius: BorderRadius.circular(2),
    );
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    seeAndMoveToPlayer(
      closePlayer: (player) {
        execAttack();
      },
      radiusVision: (GameUtils.sTileSize) * 3,
    );
  }

  @override
  void die() {
    gameRef.add(
      AnimatedObjectOnce(
        animation: GameSpriteSheet.smokeExplosion(),
        position: position,
        size: Vector2(32, 32),
      ),
    );
    removeFromParent();
    super.die();
  }

  /// 执行攻击
  void execAttack() {
    simpleAttackMelee(
      size: Vector2.all((GameUtils.tileSize) * 0.62),
      damage: attack,
      interval: 800,
      animationDown: EnemySpriteSheet.enemyAttackEffectBottom(),
      animationLeft: EnemySpriteSheet.enemyAttackEffectLeft(),
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      animationUp: EnemySpriteSheet.enemyAttackEffectTop(),
      // execute: () {
      //   Sounds.attackEnemyMelee();
      // },
    );
  }

  /// 受到伤害
  @override
  void receiveDamage(AttackFromEnum attacker, double damage, dynamic id) {
    showDamage(
      damage,
      config: TextStyle(
        fontSize: GameUtils.getSizeByTileSize(5),
        color: Colors.white,
        fontFamily: 'Normal',
      ),
    );
    super.receiveDamage(attacker, damage, id);
  }
}
