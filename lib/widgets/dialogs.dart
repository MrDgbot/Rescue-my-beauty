import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_routes.dart';
import 'package:rescue_my_beauty/topvars.dart';

import 'tap_scale_container.dart';

class Dialogs {
  static void showGameOver(BuildContext context, VoidCallback playAgain) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  "游 戏 结 束",
                  style: textStyle24B.copyWith(
                    color: Colors.orangeAccent,
                    fontSize: 52,
                  ),
                ),
                Wrap(
                  spacing: 20,
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    menuItem(
                      '重新开始',
                      playAgain,
                    ),
                    menuItem(
                      '返回主页',
                      () => Navigator.of(context)
                          .popAndPushNamed(Routes.rescueHomepage),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showMenu(BuildContext context, List<Widget> playAgain) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "游 戏 暂 停",
                style: textStyle24B.copyWith(
                  color: Colors.orangeAccent,
                  fontSize: 52,
                ),
              ),
              Wrap(
                spacing: 20,
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: playAgain,
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget menuItem(String text, VoidCallback onTap) {
    return TapScaleContainer(
      onTap: onTap,
      child: Text(text, style: textStyle20),
    );
  }
}
