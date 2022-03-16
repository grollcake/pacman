import 'package:flutter/material.dart';
import 'dart:math' as math;

class RotateWidget extends StatelessWidget {
  final Widget child;
  final int degree;

  const RotateWidget({Key? key, required this.child, required this.degree})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radians = degree * math.pi / 180;
    return Transform.rotate(angle: radians, child: child);
  }
}
