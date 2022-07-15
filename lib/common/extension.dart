import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';
import 'package:rescue_my_beauty/topvars.dart';

extension StateExt on State {
  setSafeState(VoidCallback cb) {
    if (mounted) setState(cb);
  }
}

extension GameComponentExtensions on GameComponent {
  void showCustom(
    String text, {
    TextStyle? config,
    double initVelocityTop = -5,
    double gravity = 0.5,
    double maxDownSize = 20,
    DirectionTextDamage direction = DirectionTextDamage.RANDOM,
    bool onlyUp = false,
  }) {
    if (!hasGameRef) return;
    gameRef.add(
      TextDamageComponent(
        text,
        Vector2(center.x, y),
        config: config ?? textStyle14.copyWith(color: const Color(0xFFFFFFFF)),
        initVelocityTop: initVelocityTop,
        gravity: gravity,
        direction: direction,
        onlyUp: onlyUp,
        maxDownSize: maxDownSize,
      ),
    );
  }
}
