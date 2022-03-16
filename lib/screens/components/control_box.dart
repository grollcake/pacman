import 'package:flutter/material.dart';
import 'package:pacman/model/enums.dart';
import 'package:pacman/screens/components/status_label.dart';

import 'game_button.dart';

class BuildControllBox extends StatelessWidget {
  const BuildControllBox({Key? key, required this.status, required this.elapsedSeconds, required this.controllGame})
      : super(key: key);

  final GameStatus status;
  final int elapsedSeconds;
  final VoidCallback controllGame;

  @override
  Widget build(BuildContext context) {
    String buttonText = '';
    switch (status) {
      case GameStatus.waiting:
        buttonText = 'START';
        break;
      case GameStatus.playing:
        buttonText = 'PAUSE';
        break;
      case GameStatus.paused:
        buttonText = 'RESUME';
        break;
      case GameStatus.done:
        buttonText = 'RESTART';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildStatusLabel(status: status, elapsedSeconds: elapsedSeconds),
          SizedBox(height: 6),
          BuildButton(text: buttonText, onPresssed: controllGame),
        ],
      ),
    );
  }
}
