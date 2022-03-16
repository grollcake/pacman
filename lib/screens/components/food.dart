import 'package:flutter/material.dart';
import 'package:pacman/styles/app_style.dart';

class BuildFood extends StatelessWidget {
  const BuildFood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: Container(
          width: constraints.maxWidth * .2,
          height: constraints.maxHeight * .2,
          decoration: BoxDecoration(
            color: AppStyle.foodColor,
            shape: BoxShape.circle,
          ),
        ),
      );
    });
  }
}
