import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:rescue_my_beauty/common/screen.dart';
import 'package:rescue_my_beauty/common/storage.dart';
import 'package:rescue_my_beauty/models/player_info.dart';
import 'package:rescue_my_beauty/player/nobita/local_player.dart';
import 'package:rescue_my_beauty/player/nobita/local_player_controller.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_routes.dart';
import 'package:rescue_my_beauty/topvars.dart';
import 'package:rescue_my_beauty/widgets/dialogs.dart';
import 'package:rescue_my_beauty/widgets/tap_scale_container.dart';

class InterfaceOverlay extends StatefulWidget {
  final GameController gameController;

  const InterfaceOverlay({
    Key? key,
    required this.gameController,
  }) : super(key: key);

  @override
  State<InterfaceOverlay> createState() => _InterfaceOverlayState();
}

class _InterfaceOverlayState extends State<InterfaceOverlay>
    implements GameListener {
  LocalPlayer? _player;
  final double _sizeBar = 100;

  @override
  void initState() {
    widget.gameController.addListener(this);
    _player = widget.gameController.player as LocalPlayer?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLife(),
          const Expanded(child: sizedBox),
          _buildSettings(context),
          SizedBox(
            width: min(Screen.screenHeight, Screen.screenWidth) / 4.4,
          )
        ],
      ),
    );
  }

  Widget _buildLife() {
    return StateControllerConsumer<LocalPlayerController>(
        builder: (context, controller) {
      return Container(
        margin: edge16WithStatusBar,
        padding: edge16WithStatusBar,
        decoration: BoxDecoration(
          color: Colors.brown.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '血量',
              style: textStyle14,
            ),
            Container(
              height: 10,
              width: _sizeBar,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Colors.white),
              ),
              alignment: Alignment.centerLeft,
              child: Container(
                height: 10,
                width: _player?.isDead ?? true
                    ? 0
                    : _sizeBar * (controller.life / controller.maxLife),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              '耐力',
              style: textStyle14,
            ),
            Container(
              height: 10,
              width: _sizeBar,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Colors.white),
              ),
              alignment: Alignment.centerLeft,
              child: Container(
                height: 10,
                width: _player?.isDead ?? true
                    ? 0
                    : _sizeBar * (controller.stamina / controller.maxStamina),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSettings(BuildContext context) {
    return TapScaleContainer(
      padding: edge16WithStatusBar,
      onTap: () {
        widget.gameController.gameRef.pauseEngine();
        Dialogs.showMenu(context, [
          Dialogs.menuItem(
            '重新开始',
            () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(
                      Routes.rescueGamepage, (route) => false)
                  .whenComplete(
                      () => widget.gameController.gameRef.resumeEngine());
            },
          ),
          Dialogs.menuItem('游戏存档', () {
            final p = widget.gameController.player?.position;
            StorageUtil.setJSON(
                    'game',
                    PlayerInfo(
                            id: 1,
                            loaction: Loaction(x: p?.x ?? 10, y: p?.y ?? 10))
                        .toJson())
                .then((value) {
              final String tips = value ? "存档成功" : '存档失败';
              SmartDialog.compatible.showToast(tips);
            });
          }),
          Dialogs.menuItem(
            '返回游戏',
            () {
              widget.gameController.gameRef.resumeEngine();
              Navigator.of(context).pop();
            },
          ),
          Dialogs.menuItem(
            '返回主页',
            () => Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.rescueHomepage, (route) => false),
          ),
        ]);
      },
      child: Image.asset(
        'assets/images/setting.png',
        width: 36,
        height: 36,
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    if (!mounted) return;
    // _player = widget.gameController.player as LocalPlayer?;
  }
}
