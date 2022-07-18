import 'dart:math';
import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
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
    }
    if (!component.lockMove) {
      _enemyOrcCreate(component.position);
    }
  }

  /// 敌对生物生成 Orc
  void _enemyOrcCreate(Vector2 p) {
    /// 延迟
    if (_timerEnemyOrc == null) {
      _timerEnemyOrc = async.Timer(const Duration(seconds: 8), () {
        _timerEnemyOrc = null;
      });
    } else {
      return;
    }

    debugPrint("怪物数量：${gameRef.enemies().length}");
    if (gameRef.enemies().length >= 30) return;

    /// 生成
    gameRef.add(
      LittleMonster(
        p + p * Random().nextDouble() * 2,
      ),
    );
    gameRef.add(
      LittleMonster(
        p + p * Random().nextDouble() * 2,
      ),
    );
  }

  void _verifyStamina(double dt, LocalPlayer component) {
    if (component.checkInterval('STAMINA', 150, dt) == true) {
      stamina += 2;
      if (stamina > 100) {
        stamina = 100;
      }
      notifyListeners();
    }
  }

  void decrementStamina(int i) {
    stamina -= i;
    if (stamina < 0) {
      stamina = 0;
    }
    notifyListeners();
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

  void receiveDamage(double damage, dynamic from) {
    notifyListeners();
  }

  void onMove(double speed, Direction direction) {
    if (speed > 0) {
      _sendMove(direction);
    } else {
      _sendMove(null);
    }
  }

  void _sendMove(Direction? direction) {
    if (direction != cDirection) {
      cDirection = direction;
    }
  }

  void idle() {
    _sendMove(null);
  }
}
