import 'dart:math';
import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';
import 'package:rescue_my_beauty/enemies/little_monster.dart';
import 'local_player.dart';

class LocalPlayerController extends StateController<LocalPlayer> {
  final double maxStamina = 100;
  double stamina = 100;
  double maxLife = 150;
  double life = 150;
  Direction? cDirection;

  /// Orc 敌对生物生成延迟时间
  async.Timer? _timerEnemyOrc;
  async.Timer? _staminaEnemyOrc;

  LocalPlayerController();

  @override
  void onReady(LocalPlayer component) {
    life = component.life;
    maxLife = component.maxLife;
    super.onReady(component);
  }

  @override
  void update(double dt, LocalPlayer component) {
    life = component.life;
    if (component.isDead == false) {
      _verifyStamina(dt, component);
      _enemyOrcCreate(component.position);
    }
  }

  /// 敌对生物生成 Orc
  void _enemyOrcCreate(Vector2 p) {
    /// 延迟
    if (_timerEnemyOrc == null) {
      _timerEnemyOrc = async.Timer(const Duration(seconds: 5), () {
        _timerEnemyOrc = null;
      });
    } else {
      return;
    }
    if (gameRef.enemies().length >= 18) return;

    /// 生成
    gameRef.add(
      LittleMonster(
        p + p * Random().nextDouble() * 2,
      ),
    );
  }

  void _verifyStamina(double dt, LocalPlayer component) {
    if (_staminaEnemyOrc == null) {
      _staminaEnemyOrc = async.Timer(const Duration(milliseconds: 1000), () {
        stamina += 40;
        if (stamina > 100) {
          stamina = 100;
        }
        notifyListeners();
        _staminaEnemyOrc = null;
      });
    } else {
      return;
    }

    // if (component.checkInterval('STAMINA', 2000, dt) == true) {
    //   stamina += 20;
    //   if (stamina > 100) {
    //     stamina = 100;
    //   }
    //   notifyListeners();
    // }
  }

  void decrementStamina(int i) {
    stamina -= i;
    if (stamina < 0) {
      stamina = 0;
    }
  }

  void joystickAction(JoystickActionEvent action) {
    if (action.id == LogicalKeyboardKey.space.keyId &&
        action.event == ActionEvent.DOWN) {
      _tryExecAttack();
    }
    if (action.id == 0 && action.event == ActionEvent.DOWN) {
      _tryExecAttack();
    }
    if (action.id == 1 && action.event == ActionEvent.DOWN) {
      _tryExecAttackRange();
    }
  }

  void _tryExecAttack() {
    if (stamina < 10 || component?.isDead == true) {
      return;
    }

    decrementStamina(10);
    component?.execAttack();
    notifyListeners();
  }

  void _tryExecAttackRange() {
    if (stamina < 20 || component?.isDead == true) {
      return;
    }
    decrementStamina(20);
    component?.actionAttackRange();
    notifyListeners();
  }
}
