import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/extension.dart';
import 'package:rescue_my_beauty/common/utils.dart';
import 'package:rescue_my_beauty/topvars.dart';

/// 生命药水
/// [作用] 恢复血量
/// [参数] initPosition 初始化坐标
/// [参数] life 可自定义 默认30
class PotionLife extends GameDecoration with Sensor {
  final Vector2 initPosition;
  final double life;

  PotionLife(this.initPosition, {this.life = 30})
      : super.withSprite(
            sprite: Sprite.load('items/potion_red.png'),
            position: initPosition,
            size: Vector2(GameUtils.sTileSize, GameUtils.sTileSize));

  @override
  void onContact(GameComponent component) {
    if (component is Player) {
      showCustom(
        "+ ${life.toInt().toString()}",
        initVelocityTop: -10,
        config: textStyleNum.copyWith(color: Colors.redAccent),
      );

      gameRef.player?.addLife(life);
      removeFromParent();
    }
  }
}
