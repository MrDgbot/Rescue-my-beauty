import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/decoration/door_key.dart';
import 'package:rescue_my_beauty/player/enemy_sprite_sheet.dart';
import 'package:rescue_my_beauty/player/game_sprite_sheet.dart';

class Boss extends SimpleEnemy with ObjectCollision, Lighting {
  final Vector2 initPosition;
  double attack = 25;

  bool addChild = false;
  bool _seePlayerClose = false;
  List<Enemy> childrenEnemy = [];

  Boss(this.initPosition)
      : super(
          animation: EnemySpriteSheet.animationBySpriteSheetTest(
              EnemySpriteSheet.boss),
          position: initPosition,
          size: Vector2(GameUtils.sTileSize * 3, GameUtils.sTileSize * 3),
          speed: (GameUtils.sTileSize) / 0.25,
          life: 200,
        ) {
    /// 发光
    setupLighting(
      LightingConfig(
        radius: width * 4,
        blurBorder: width * 4,
        color: Colors.transparent,
      ),
    );

    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(GameUtils.sTileSize * 1.9, GameUtils.sTileSize * 2.2),
            align: Vector2(width * 0.2, height * 0.25),
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
          radiusVision: (GameUtils.sTileSize) * 3,
        );
      },
      radiusVision: (GameUtils.sTileSize) * 3,
    );
    if (!_seePlayerClose) {
      seeAndMoveToAttackRange(
        positioned: (p) {
          execAttackRange();
        },
        radiusVision: (GameUtils.sTileSize) * 5,
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
    gameRef.add(
      DoorKey(
        position,
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
            size: Vector2((GameUtils.sTileSize) / 2, (GameUtils.sTileSize) / 2),
          ),
        ],
      ),
      lightingConfig: LightingConfig(
        radius: (GameUtils.sTileSize) * 0.9,
        blurBorder: (GameUtils.sTileSize) / 2,
        color: Colors.deepOrangeAccent.withOpacity(0.4),
      ),
    );
  }

  void execAttack() {
    simpleAttackMelee(
      size: Vector2.all((GameUtils.sTileSize) * 0.62),
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
