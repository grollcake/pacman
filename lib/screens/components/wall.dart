import 'package:flutter/material.dart';

class BuildWall extends StatelessWidget {
  const BuildWall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.blue.shade900,
        child: Container(
          margin: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue.shade600,
          ),
        ),
      ),
    );
  }
}
