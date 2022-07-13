import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/player/sprite_sheet_hero.dart';

double tileSize = 20.0;

class LocalPlayer extends SimplePlayer with Lighting, ObjectCollision {
  static double maxSpeed = tileSize * 10;
  final int id;
  final String nick;

  bool lockMove = false;

  LocalPlayer(this.id, this.nick, Vector2 position)
      : super(
          position: position,
          animation:
              SpriteSheetHero.animationBySpriteSheet(SpriteSheetHero.hero1),
          speed: maxSpeed,
          life: 100,
          size: Vector2.all(tileSize * 3.5),
        ) {
    /// 发光
    setupLighting(
      LightingConfig(
        radius: width*1.7,
        blurBorder: width*1.7,
        color: Colors.transparent,
      ),
    );

    /// 碰撞
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(valueByTileSize(14), valueByTileSize(14)),
            align: Vector2(0, 0),
          ),
        ],
      ),
    );
  }

  double valueByTileSize(double value) {
    return value * (tileSize/4);
  }

  @override
  void render(Canvas canvas) {
    if (!isDead) {
      /// 生命条
      drawDefaultLifeBar(
        canvas,
        drawInBottom: true,
        margin: 0,
        width: tileSize * 1.5,
        borderWidth: tileSize / 5,
        height: tileSize / 5,
        borderColor: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
        align: Offset(
          tileSize * 1,
          tileSize * 4,
        ),
      );
    }
    super.render(canvas);
  }

  /// 碰撞触发
  @override
  bool onCollision(GameComponent component, bool active) {
    bool active = true;
    print("发生碰撞");

    /// 碰撞 Orc 不发生碰撞
    // if (component is Orc) {
    //   debugPrint("碰撞 Orc");
    //   active = false;
    // }
    return active;
  }

  /// 操纵手柄操作控制
  @override
  void joystickAction(JoystickActionEvent event) {
    // if (hasController) {
    //   controller.joystickAction(event);
    // }
    // if (action.id == LogicalKeyboardKey.space.keyId &&
    //     action.event == ActionEvent.DOWN) {
    //   _tryExecAttack();
    // }
    // if (action.id == 0 && action.event == ActionEvent.DOWN) {
    //   _tryExecAttack();
    // }
    //
    // /// 死亡 || 锁住移动
    // if (isDead || lockMove) return;
    //
    // /// 攻击
    // if ((event.id == LogicalKeyboardKey.space.keyId ||
    //         event.id == LogicalKeyboardKey.select.keyId ||
    //         event.id == 1) &&
    //     event.event == ActionEvent.DOWN) {
    //   /// 攻击动画
    //   // _addAttackAnimation();
    //
    //   /// 攻击范围
    //   simpleAttackMelee(
    //     damage: 10,
    //     size: Vector2.all(tileSize * 1.5),
    //     withPush: false,
    //   );
    // }
    super.joystickAction(event);
  }

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
    if (!isDead) {
      showDamage(
        damage,
        initVelocityTop: -2,
        config: TextStyle(color: Colors.white, fontSize: tileSize / 2),
      );
      // lockMove = true;
      /// 屏幕变红
      gameRef.lighting
          ?.animateToColor(const Color(0xFF630000).withOpacity(0.7));
      // gameRef.add(
      //   Orc(
      //     Vector2(
      //       (gameRef.player?.position.x ?? 0) - Random().nextInt(20),
      //       (gameRef.player?.position.y ?? 0) - Random().nextInt(20),
      //     ),
      //   ),
      // );
      idle();
      // _addDamageAnimation(() {
      //   lockMove = false;
      //   gameRef.lighting?.animateToColor(Colors.black.withOpacity(0.7));
      // });
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

  void execAttack() {
    final anim = SpriteSheetHero.attackAxe;
    simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationUp: anim,
      animationDown: anim,
      animationDestroy: SpriteSheetHero.smokeExplosion,
      size: Vector2.all(tileSize * 0.9),
      speed: speed * 3,
      damage: 15,
      enableDiagonal: false,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(tileSize * 0.9, tileSize * 0.9),
          )
        ],
      ),
    );
  }
}
