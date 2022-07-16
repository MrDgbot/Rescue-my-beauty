import 'package:rescue_my_beauty/common/utils.dart';

// ignore: constant_identifier_names
const    TILE_SIZE_SPRITE_SHEET = 16;
double valueByTileSize(double value) {
  return value * (GameUtils.sTileSize / TILE_SIZE_SPRITE_SHEET);
}