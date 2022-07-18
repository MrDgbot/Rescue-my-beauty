import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/screen.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/game_sprite_sheet.dart';
import 'package:rescue_my_beauty/player/nobita/local_player_controller.dart';
import 'package:rescue_my_beauty/player/sprite_sheet_hero.dart';
import 'package:rescue_my_beauty/topvars.dart';

class LocalPlayer extends SimplePlayer
    with Lighting, ObjectCollision, UseStateController<LocalPlayerController> {
  final int id;
  final String nick;
  final SpriteSheet spriteSheet;
  bool containKey = false;

  static const double _playerRatio = 1.1;
  static final double maxSpeed = GameUtils.sTileSize * (Screen.getRatio + 2.4);

  bool lockMove = false;

  LocalPlayer(this.id, this.nick, Vector2 position, this.spriteSheet)
      : super(
          position: position,
          animation: SpriteSheetHero.animationBySpriteSheet(spriteSheet),
          speed: maxSpeed,
          life: 150,
          size: Vector2.all(GameUtils.sTileSize / _playerRatio),
        ) {
    /// 发光
    setupLighting(
      LightingConfig(
        radius: width * 2,
        blurBorder: width * 2,
        color: Colors.transparent,
      ),
    );

    /// 人物碰撞
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(GameUtils.sTileSize / _playerRatio,
                GameUtils.sTileSize / _playerRatio),
            align: Vector2(0, 0),
          ),
        ],
      ),
    );
  }

  /// 碰撞触发
  @override
  bool onCollision(GameComponent component, bool active) {
    bool active = true;

    /// SimpleEnemy 不发生碰撞
    if (component is SimpleEnemy) {
      active = false;
    }
    if (component is FlyingAttackObject &&
        component.attackFrom == AttackFromEnum.PLAYER_OR_ALLY) {
      active = false;
    }
    return active;
  }

  /// 攻击 移动斧头 存在缺陷，人物碰撞会消失。
  // void execAttack() {
  //   final anim = SpriteSheetHero.attackAxe;
  //   simpleAttackRange(
  //     id: id,
  //     animationRight: anim,
  //     animationLeft: anim,
  //     animationUp: anim,
  //     animationDown: anim,
  //     withCollision: false,
  //     damage: 15,
  //     size: Vector2(GameUtils.tileSize * 2, GameUtils.tileSize * 2),
  //     collision: CollisionConfig(
  //       collisions: [
  //         CollisionArea.rectangle(
  //           size: Vector2(GameUtils.tileSize * 2, GameUtils.tileSize * 2),
  //         )
  //       ],
  //     ),
  //   );
  // }
  /// 近战攻击
  void execAttack() {
    // final anim = SpriteSheetHero.lightBlade;
    simpleAttackMelee(
      id: id,
      damage: 10,
      animationDown: SpriteSheetHero.attackEffectBottom(),
      animationLeft: SpriteSheetHero.attackEffectLeft(),
      animationRight: SpriteSheetHero.attackEffectRight(),
      animationUp: SpriteSheetHero.attackEffectTop(),
      size: Vector2(GameUtils.tileSize * 2, GameUtils.tileSize * 4),
    );
    // simpleAttackMelee(
    //   id: id,
    //   animationLeft: Future.value(anim.createAnimation(row: 1, stepTime: 0.05)),
    //   animationRight:
    //       Future.value(anim.createAnimation(row: 0, stepTime: 0.05)),
    //   animationUp: Future.value(anim.createAnimation(row: 2, stepTime: 0.05)),
    //   animationDown: Future.value(anim.createAnimation(row: 3, stepTime: 0.05)),
    //   size: Vector2(GameUtils.tileSize * 2, GameUtils.tileSize * 4),
    //   damage: 10,
    // );
  }

  /// 远程火球
  void actionAttackRange() {
    simpleAttackRange(
      id: id,
      animationRight: GameSpriteSheet.fireBallAttackRight(),
      animationLeft: GameSpriteSheet.fireBallAttackLeft(),
      animationUp: GameSpriteSheet.fireBallAttackTop(),
      animationDown: GameSpriteSheet.fireBallAttackBottom(),
      animationDestroy: GameSpriteSheet.fireBallExplosion(),
      size: Vector2(GameUtils.sTileSize * 0.65, GameUtils.sTileSize * 0.65),
      damage: 20,
      speed: maxSpeed * (GameUtils.sTileSize / 36),
      enableDiagonal: false,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
              size: Vector2(GameUtils.sTileSize / 2, GameUtils.sTileSize / 2)),
        ],
      ),
      lightingConfig: LightingConfig(
        radius: GameUtils.sTileSize * 0.9,
        blurBorder: GameUtils.sTileSize / 2,
        color: Colors.deepOrangeAccent.withOpacity(0.4),
      ),
    );
  }

  /// 操纵手柄操作控制
  @override
  void joystickAction(JoystickActionEvent event) {
    if (lockMove || isDead) return;
    if (hasController) {
      controller.joystickAction(event);
    }
    super.joystickAction(event);
  }

  /// 移动操纵杆时调用的方法。
  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (lockMove || isDead) {
      return;
    }
    speed = maxSpeed * event.intensity;
    super.joystickChangeDirectional(event);
  }

  /// 受伤触发
  @override
  void receiveDamage(AttackFromEnum attacker, double damage, dynamic from) {
    if (from == id || from == AttackFromEnum.PLAYER_OR_ALLY) {
      return super.receiveDamage(attacker, damage, from);
    }

    if (!isDead) {
      showDamage(
        damage,
        initVelocityTop: -10,
        config: textStyleNum.copyWith(color: Colors.amberAccent),
      );

      /// 屏幕变红
      gameRef.lighting
          ?.animateToColor(const Color(0xFF630000).withOpacity(0.7));
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!isDead) {
          gameRef.lighting?.animateToColor(GameUtils.bgColor);
        }
      });
    }
    super.receiveDamage(attacker, damage, from);
  }

  @override
  void die() {
    life = 0;
    gameRef.add(
      AnimatedObjectOnce(
        animation: SpriteSheetHero.smokeExplosion,
        position: position,
        size: size,
      ),
    );
    gameRef.add(
      GameDecoration.withSprite(
        sprite: Sprite.load('crypt.png'),
        position: Vector2(
          position.x,
          position.y,
        ),
        size: size,
      ),
    );
    removeFromParent();
    super.die();
  }
}
