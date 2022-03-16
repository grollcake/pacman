import 'package:flutter/material.dart';
import 'package:pacman/model/enums.dart';
import 'package:pacman/utils/common_funtions.dart';

class BuildStatusLabel extends StatelessWidget {
  final GameStatus _status;
  final int _elapsedSeconds;

  const BuildStatusLabel({Key? key, required status, required elapsedSeconds})
      : _status = status,
        _elapsedSeconds = elapsedSeconds,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_status == GameStatus.waiting) {
      return Text(
        'Waiting',
        style: TextStyle(color: Colors.grey[200], fontSize: 16),
      );
    } else if (_status == GameStatus.playing) {
      return Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              color: Colors.green[400],
              strokeWidth: 2.0,
            ),
          ),
          SizedBox(width: 8),
          Text(
            timeFormatter(seconds: _elapsedSeconds),
            style: TextStyle(color: Colors.green[400], fontSize: 16),
          )
        ],
      );
    } else if (_status == GameStatus.paused) {
      return Row(
        children: [
          Icon(Icons.pause, size: 14, color: Colors.pink[300]),
          SizedBox(width: 8),
          Text(
            timeFormatter(seconds: _elapsedSeconds),
            style: TextStyle(color: Colors.pink[300], fontSize: 16),
          )
        ],
      );
    }
    else if (_status == GameStatus.done) {
      return Text(
        'Gameover',
        style: TextStyle(color: Colors.grey[200], fontSize: 16),
      );
    }
    else {
      return SizedBox();
    }
  }
}
