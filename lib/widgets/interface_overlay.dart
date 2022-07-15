import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/common/screen.dart';
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
          // Align(
          //   alignment: Alignment.topRight,
          //   child: _buildSettings(context),
          // )
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
                width: _sizeBar * (controller.life / controller.maxLife),
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
                width: _sizeBar * (controller.stamina / controller.maxStamina),
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
                      Routes.rescueGamepage, (route) => true)
                  .whenComplete(
                      () => widget.gameController.gameRef.resumeEngine());
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

  // Widget _buildPlayersOn() {
  //   return Opacity(
  //     opacity: 0.8,
  //     child: Container(
  //       margin: const EdgeInsets.all(10),
  //       padding: const EdgeInsets.all(10),
  //       height: 150,
  //       width: 100,
  //       decoration: BoxDecoration(
  //         color: Colors.brown,
  //         borderRadius: BorderRadius.circular(5),
  //         border: Border.all(color: Colors.black),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Playes on',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 10,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           Container(
  //             width: 100,
  //             height: 1,
  //             color: Colors.white.withOpacity(0.5),
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           Expanded(
  //             child: ListView.builder(
  //               itemCount: nickNames.length,
  //               itemBuilder: (context, index) {
  //                 return Text(
  //                   nickNames[index],
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 12,
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    if (!mounted) return;
    // _player = widget.gameController.player as LocalPlayer?;
    // if (_player != null) {
    //   if (life != _player!.life || stamina != _player!.stamina) {
    //     setState(() {
    //       life = _player!.life;
    //       stamina = _player!.stamina;
    //     });
    //   }
    // }
    // if (nickNames.length !=
    //     (widget.gameController.livingEnemies?.length ?? 0)) {
    //   setState(() {
    //     nickNames = widget.gameController.livingEnemies?.map((e) {
    //           return (e as RemotePlayer).nick;
    //         }).toList() ??
    //         [];
    //   });
    // }
  }
}
