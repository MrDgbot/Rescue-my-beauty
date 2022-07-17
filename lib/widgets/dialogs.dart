import 'dart:math';

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
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  buildGameText('游戏结束'),
                  Wrap(
                    spacing: 25,
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
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                buildGameText('游戏暂停'),
                Wrap(
                  spacing: 25,
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: playAgain,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget buildGameText(String text, {double? fontSize}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text.split('').join(' '),
          style: textStyle24B.copyWith(
            color: Colors.orangeAccent,
            fontSize: fontSize ?? 58,
            shadows: List.generate(
              8,
              (index) => Shadow(
                color: Colors.white,
                offset: Offset.fromDirection(pi / 4 * index),
                blurRadius: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget menuItem(String text, VoidCallback onTap) {
    return TapScaleContainer(
      onTap: onTap,
      child: Text(text, style: textStyle24B),
    );
  }
}
