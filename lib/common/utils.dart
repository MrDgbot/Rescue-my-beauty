import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/screen.dart';

class GameUtils {
  const GameUtils._();

  /// 地图块
  static const double tileSize = 16;

  /// 背景颜色
  static final Color bgColor = Colors.black.withOpacity(0.9);

  /// 是否开启开局相机移动
  static bool isStartCameraMove = true;

  /// 屏幕块
  static final sTileSize = max(Screen.screenHeight, Screen.screenWidth) / 10;

  /// 转换像素
  static double getSizeByTileSize(double size) {
    return size * (sTileSize / tileSize);
  }

  /// 转换像素
  static double getRandomDamage(double size) {
    return size * (sTileSize / tileSize);
  }
}
