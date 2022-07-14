import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/player/sprite_sheet_hero.dart';

class LocalPlayer extends SimplePlayer with Lighting, ObjectCollision {
  final int id;
  final String nick;

  static const double _playerRatio = 1.1;
  static final double maxSpeed = GameUtils.sTileSize * 5;

  bool lockMove = false;

  LocalPlayer(this.id, this.nick, Vector2 position)
      : super(
          position: position,
          animation:
              SpriteSheetHero.animationBySpriteSheet(SpriteSheetHero.hero1),
          speed: maxSpeed,
          life: 100,
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

  @override
  void render(Canvas canvas) {
    if (!isDead) {
      /// 生命条
      drawDefaultLifeBar(
        canvas,
        drawInBottom: true,
        margin: 0,
        width: GameUtils.tileSize * 2.5,
        borderWidth: GameUtils.tileSize / 4,
        height: GameUtils.tileSize / 4,
        borderColor: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
        align: Offset(GameUtils.sTileSize / 5, GameUtils.sTileSize),
      );
    }
    super.render(canvas);
  }

  /// 碰撞触发
  @override
  bool onCollision(GameComponent component, bool active) {
    bool active = true;

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
    if (!isDead) {
      showDamage(
        damage,
        initVelocityTop: -10,
        config: TextStyle(
            color: Colors.amberAccent, fontSize: GameUtils.sTileSize / 4),
      );
      lockMove = true;
      /// 屏幕变红
      gameRef.lighting
          ?.animateToColor(const Color(0xFF630000).withOpacity(0.7));
      Future.delayed(const Duration(milliseconds: 500), () {
        if(!isDead){
          idle();
          lockMove = false;
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

  /// 攻击
  void execAttack() {
    final anim = SpriteSheetHero.attackAxe;
    simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationUp: anim,
      animationDown: anim,
      animationDestroy: SpriteSheetHero.smokeExplosion,
      size: Vector2.all(GameUtils.tileSize * 0.9),
      speed: speed * 3,
      damage: 15,
      enableDiagonal: false,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(GameUtils.tileSize * 0.9, GameUtils.tileSize * 0.9),
          )
        ],
      ),
    );
  }
}
