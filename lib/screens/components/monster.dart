import 'package:flutter/material.dart';

class BuildMonster extends StatelessWidget {
  const BuildMonster({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Image.asset('assets/image/monster.png'),
    );
  }
}
