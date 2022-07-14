import 'package:flutter/material.dart';

import 'package:bonfire/bonfire.dart';

class Boss extends GameDecoration with Lighting  {
  final double? zoom;

  Boss(
      Vector2 position,
      Vector2 size, {
        this.zoom = 1.5,
      }) : super(
    position: position,
    size: size,
  ) {
    setupLighting(
      LightingConfig(
        radius: width * zoom!,
        blurBorder: width * zoom!,
        color: Colors.orange.withOpacity(0.2),
        withPulse: true,
      ),
    );
  }

}
