import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';
import 'package:rescue_my_beauty/topvars.dart';

extension SafeSetStateExtension on State {
  /// [setState] when it's not building, then wait until next frame built.
  FutureOr<void> safeSetState(FutureOr<dynamic> Function() fn) async {
    await fn();
    if (mounted &&
        !context.debugDoingBuild &&
        context.owner?.debugBuilding == false) {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    }
    final Completer<void> completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      completer.complete();
    });
    return completer.future;
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
