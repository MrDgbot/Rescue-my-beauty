import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';

import 'local_player.dart';

class LocalPlayerController extends StateController<LocalPlayer> {
  final double maxStamina = 100;
  double stamina = 100;
  double maxLife = 100;
  double life = 100;
  Direction? cDirection;

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
