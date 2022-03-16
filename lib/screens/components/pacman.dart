import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:pacman/model/enums.dart';
import 'package:pacman/utils/rotate_widget.dart';

class BuildPacman extends StatelessWidget {
  const BuildPacman({Key? key, required this.direction, required this.mouseOpened}) : super(key: key);

  final UnitDirection direction;
  final bool mouseOpened;

  @override
  Widget build(BuildContext context) {
    int degree = 0;
    if (direction == UnitDirection.up) {
      degree = 270;
    } else if (direction == UnitDirection.down) {
      degree = 90;
    } else if (direction == UnitDirection.left) {
      degree = 180;
    } else if (direction == UnitDirection.right) {
      degree = 0;
    }

    Widget pacman = Container();

    if (mouseOpened) {
      pacman = RotateWidget(
        child: Image.asset('assets/image/pacman.png'),
        degree: degree,
      );
    } else {
      pacman = Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFFF1C)),
      );
    }

    return LayoutBuilder(
      builder: ((_, BoxConstraints constraints) {
        double width = constraints.maxWidth * 0.8;
        double height = constraints.maxHeight * 0.8;
        return Center(
          child: Container(width: width, height: height, child: pacman),
        );
      }),
    );
  }
}
