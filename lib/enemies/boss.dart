import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/enemy_sprite_sheet.dart';
import 'package:rescue_my_beauty/player/game_sprite_sheet.dart';
import 'package:rescue_my_beauty/player/nobita/functions.dart';

class Boss extends SimpleEnemy with ObjectCollision {
  final Vector2 initPosition;
  double attack = 40;

  bool addChild = false;
  bool _seePlayerClose = false;
  List<Enemy> childrenEnemy = [];

  Boss(this.initPosition)
      : super(
          animation: EnemySpriteSheet.bossAnimations(),
          position: initPosition,
          size:
              Vector2((GameUtils.sTileSize) * 1.5, (GameUtils.sTileSize) * 1.7),
          speed: (GameUtils.sTileSize) / 0.25,
          life: 200,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(valueByTileSize(14), valueByTileSize(16)),
            align: Vector2(valueByTileSize(5), valueByTileSize(11)),
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
          radiusVision: (GameUtils.tileSize) * 3,
        );
      },
      radiusVision: (GameUtils.tileSize) * 3,
    );
    if (!_seePlayerClose) {
      seeAndMoveToAttackRange(
        positioned: (p) {
          execAttackRange();
        },
        radiusVision: (GameUtils.tileSize) * 5,
      );
    }
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

  void execAttackRange() {
    simpleAttackRange(
      animationRight: GameSpriteSheet.fireBallAttackRight(),
      animationLeft: GameSpriteSheet.fireBallAttackLeft(),
      animationUp: GameSpriteSheet.fireBallAttackTop(),
      animationDown: GameSpriteSheet.fireBallAttackBottom(),
      animationDestroy: GameSpriteSheet.fireBallExplosion(),
      size: Vector2.all((GameUtils.tileSize) * 0.65),
      damage: attack,
      speed: speed * ((GameUtils.tileSize) / 32),
      // execute: () {
      //   Sounds.attackRange();
      // },
      // onDestroy: () {
      //   Sounds.explosion();
      // },
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2((GameUtils.tileSize) / 2, (GameUtils.tileSize) / 2),
          ),
        ],
      ),
      lightingConfig: LightingConfig(
        radius: (GameUtils.tileSize) * 0.9,
        blurBorder: (GameUtils.tileSize) / 2,
        color: Colors.deepOrangeAccent.withOpacity(0.4),
      ),
    );
  }

  void execAttack() {
    simpleAttackMelee(
      size: Vector2.all((GameUtils.tileSize) * 0.62),
      damage: attack,
      interval: 1500,
      animationDown: EnemySpriteSheet.enemyAttackEffectBottom(),
      animationLeft: EnemySpriteSheet.enemyAttackEffectLeft(),
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      animationUp: EnemySpriteSheet.enemyAttackEffectTop(),
      // execute: () {
      //   Sounds.attackEnemyMelee();
      // },
    );
  }

  @override
  void receiveDamage(AttackFromEnum attacker, double damage, dynamic id) {
    showDamage(
      damage,
      config: TextStyle(
        fontSize: valueByTileSize(5),
        color: Colors.white,
        fontFamily: 'Normal',
      ),
    );
    super.receiveDamage(attacker, damage, id);
  }
}
