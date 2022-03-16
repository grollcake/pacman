import 'package:flutter/material.dart';

class BuildScoreBox extends StatelessWidget {
  const BuildScoreBox({
    Key? key,
    required this.score,
  }) : super(key: key);

  final int score;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Score',
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            score.toString(),
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.white, fontSize: 46, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
