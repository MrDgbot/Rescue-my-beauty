import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/enemy_sprite_sheet.dart';
import 'package:rescue_my_beauty/player/game_sprite_sheet.dart';

class MiniBoss extends SimpleEnemy with ObjectCollision {
  final Vector2 initPosition;
  double attack = 15;
  bool _seePlayerClose = false;

  MiniBoss(this.initPosition)
      : super(
          animation: EnemySpriteSheet.animationBySpriteSheetTest(
              EnemySpriteSheet.miniBoss),
          position: initPosition,
          size: Vector2(GameUtils.sTileSize * 0.68, GameUtils.sTileSize * 0.93),
          speed: GameUtils.sTileSize / 0.35,
          life: 120,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(
                GameUtils.getSizeByTileSize(6), GameUtils.getSizeByTileSize(7)),
            align: Vector2(GameUtils.getSizeByTileSize(2.5),
                GameUtils.getSizeByTileSize(8)),
          ),
        ],
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    drawDefaultLifeBar(canvas);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _seePlayerClose = false;
    seePlayer(
      observed: (player) {
        _seePlayerClose = true;
        seeAndMoveToPlayer(
          closePlayer: (player) {
            execAttack();
          },
          radiusVision: GameUtils.sTileSize * 2,
        );
      },
      radiusVision: GameUtils.sTileSize * 2,
    );
    if (!_seePlayerClose) {
      seeAndMoveToAttackRange(
        positioned: (p) {
          execAttackRange();
        },
        radiusVision: GameUtils.sTileSize * 3,
      );
    }
  }

  @override
  void die() {
    gameRef.add(
      AnimatedObjectOnce(
        animation: GameSpriteSheet.smokeExplosion(),
        position: position,
        size: Vector2.all(GameUtils.sTileSize),
      ),
    );
    removeFromParent();
    super.die();
  }

  void execAttackRange() {
    simpleAttackRange(
      animationRight: GameSpriteSheet.fireBallAttackRight(),
      // animationLeft: GameSpriteSheet.fireBallAttackLeft(),
      // animationUp: GameSpriteSheet.fireBallAttackTop(),
      // animationDown: GameSpriteSheet.fireBallAttackBottom(),
      animationDestroy: GameSpriteSheet.fireBallExplosion(),
      size: Vector2.all(GameUtils.sTileSize * 0.65),
      damage: attack,
      speed: speed * (GameUtils.sTileSize / 32),
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(GameUtils.sTileSize / 2, GameUtils.sTileSize / 2),
          ),
        ],
      ),
      lightingConfig: LightingConfig(
        radius: GameUtils.sTileSize * 0.9,
        blurBorder: GameUtils.sTileSize / 2,
        color: Colors.deepOrangeAccent.withOpacity(0.4),
      ),
    );
  }

  void execAttack() {
    simpleAttackMelee(
      size: Vector2.all(GameUtils.sTileSize * 0.62),
      damage: attack / 3,
      interval: 300,
      // animationDown: EnemySpriteSheet.enemyAttackEffectBottom(),
      // animationLeft: EnemySpriteSheet.enemyAttackEffectLeft(),
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      // animationUp: EnemySpriteSheet.enemyAttackEffectTop(),
    );
  }

  @override
  void receiveDamage(AttackFromEnum attacker, double damage, dynamic identify) {
    showDamage(
      damage,
      config: TextStyle(
        fontSize: GameUtils.getSizeByTileSize(5),
        color: Colors.white,
      ),
    );
    super.receiveDamage(attacker, damage, identify);
  }
}
