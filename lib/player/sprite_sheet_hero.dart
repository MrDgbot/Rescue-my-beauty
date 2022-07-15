import 'dart:ui';

import 'package:bonfire/bonfire.dart';

class SpriteSheetHero {
  static late SpriteSheet hero1;
  static late SpriteSheet hero2;
  static late SpriteSheet hero3;
  static late SpriteSheet hero4;
  // static late SpriteSheet hero5;
  // static late SpriteSheet spriteSheetEmotes;

  static load() async {
    hero1 = await _create('player/nobita.png', columns: 4);
    hero2 = await _create('player/fat_tiger.png', columns: 4);
    hero3 = await _create('player/doraemon.png', columns: 4);
    hero4 = await _create('player/shizuka.png', columns: 4);
    // hero2 = await _create('heroes/hero2.png', columns: 4);
    // hero3 = await _create('heroes/hero3.png', columns: 4);
    // hero4 = await _create('heroes/hero4.png', columns: 4);
    // hero5 = await _create('heroes/hero5.png', columns: 4);
    // spriteSheetEmotes =
    //     await _create('emotes/emotes1.png', rows: 10, columns: 8);
  }

  static Future<SpriteSheet> _create(String path,
      {int columns = 4, int rows = 4}) async {
    Image image = await Flame.images.load(path);
    return SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: columns,
      rows: rows,
    );
  }

  static Future<SpriteAnimation> get smokeExplosion => SpriteAnimation.load(
        "smoke_explosin.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          textureSize: Vector2(16, 16),
          stepTime: 0.1,
        ),
      );

  static Future<SpriteAnimation> get attackAxe => SpriteAnimation.load(
        "axe_spin_atack.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          textureSize: Vector2(148, 148),
          stepTime: 0.05,
        ),
      );

  static SimpleDirectionAnimation animationBySpriteSheet(
      SpriteSheet spriteSheet) {
    const List<double> stillList = [60, 0.001, 60];

    return SimpleDirectionAnimation(
      idleDown: Future.value(
        spriteSheet.createAnimationWithVariableStepTimes(
            row: 0, to: 3, stepTimes: stillList),
      ),
      idleLeft: Future.value(
        spriteSheet.createAnimationWithVariableStepTimes(
            row: 1, to: 3, stepTimes: stillList),
      ),
      idleRight: Future.value(
        spriteSheet.createAnimationWithVariableStepTimes(
            row: 2, to: 3, stepTimes: stillList),
      ),
      idleUp: Future.value(
        spriteSheet.createAnimationWithVariableStepTimes(
            row: 3, to: 3, stepTimes: stillList),
      ),
      runDown: Future.value(
        spriteSheet.createAnimation(row: 0, stepTime: 0.1),
      ),
      runLeft: Future.value(
        spriteSheet.createAnimation(row: 1, stepTime: 0.1),
      ),
      runRight: Future.value(
        spriteSheet.createAnimation(row: 2, stepTime: 0.1),
      ),
      runUp: Future.value(
        spriteSheet.createAnimation(row: 3, stepTime: 0.1),
      ),
    );
  }
}
