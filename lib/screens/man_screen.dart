import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman/model/enums.dart';
import 'package:pacman/model/stage_map.dart';
import 'package:pacman/screens/components/control_box.dart';
import 'package:pacman/styles/app_style.dart';
import 'package:pacman/utils/blink_widget.dart';

import 'components/food.dart';
import 'components/monster.dart';
import 'components/pacman.dart';
import 'components/score_box.dart';
import 'components/wall.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int countInRows = 11;
  int countInCols = 17;
  int countTotal = 0;
  int _pacmanPos = 0;
  UnitDirection _pacmanDirection = UnitDirection.right;
  int _monsterPos = 0;
  UnitDirection _monsterDirection = UnitDirection.right;
  int _score = 0;
  GameStatus _status = GameStatus.waiting;
  Timer? _timer;
  DateTime? _lastStartTime;
  int _elapsedSeconds = 0;
  int _elapsedSecondsBefore = 0;
  bool _pacmanMouseOpened = true;
  bool _isWon = false;

  @override
  void initState() {
    super.initState();
    countTotal = countInRows * countInCols;

    _initGame();
  }

  void _initGame() {
    for (var i = 0; i < countTotal; i++) {
      if (!wallsMap.contains(i)) {
        foodsMap.add(i);
      }
    }

    // 음식의 마지막 위치에 팩맨 배치
    _pacmanPos = foodsMap.removeLast();

    // 음식의 첫번째 위치에 몬스터 배치
    _monsterPos = foodsMap.first;

    // 게임 상태들 초기화
    _score = 0;
    _status = GameStatus.waiting;
    _pacmanDirection = UnitDirection.right;
    _lastStartTime = null;
    _elapsedSeconds = 0;
    _elapsedSecondsBefore = 0;
    _pacmanMouseOpened = true;
    _isWon = false;
  }

  void _controllGame() {
    if (_status == GameStatus.waiting || _status == GameStatus.paused) {
      _status = GameStatus.playing;
      _lastStartTime = DateTime.now();
      movePacman();
      _timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
        movePacman();
      });
    } else if (_status == GameStatus.playing) {
      _status = GameStatus.paused;
      _elapsedSecondsBefore = _elapsedSeconds;
      _timer!.cancel();
      _pacmanMouseOpened = true; // 잠깐 멈출 때는 무조건 입을 열고 있게해야 안 이상해 보여
      setState(() {});
    } else if (_status == GameStatus.done) {
      _initGame();
      _controllGame();
    }
  }

  void movePacman() {
    int oldPacmanPos = _pacmanPos;
    int oldMonsterPos = _monsterPos;

    // 게임 경과 시간 계산
    if (_status == GameStatus.playing) {
      // 플레이 중에는 경과 시간을 누적한다.
      _elapsedSeconds = (DateTime.now().difference(_lastStartTime!)).inSeconds;

      // 잠깐 멈췄다가 재시작한 경우에는 직전 경과 시간도 더한다.
      _elapsedSeconds += _elapsedSecondsBefore;
    }

    // 팩맨 다음 위치 선택
    if (_pacmanDirection == UnitDirection.right && !wallsMap.contains(_pacmanPos + 1)) {
      _pacmanPos++;
    } else if (_pacmanDirection == UnitDirection.left && !wallsMap.contains(_pacmanPos - 1)) {
      _pacmanPos--;
    } else if (_pacmanDirection == UnitDirection.up && !wallsMap.contains(_pacmanPos - countInRows)) {
      _pacmanPos -= countInRows;
    } else if (_pacmanDirection == UnitDirection.down && !wallsMap.contains(_pacmanPos + countInRows)) {
      _pacmanPos += countInRows;
    }

    // 몬스터 다음 위치 선택
    moveMonster();

    // 몬스터에게 잡혔는지 확인
    if (_pacmanPos == _monsterPos || (_pacmanPos == oldMonsterPos && _monsterPos == oldPacmanPos)) {
      _timer!.cancel();

      setState(() {
        _isWon = false;
        _pacmanPos = -1; // 화면에서 안 보이게 처리
        _status = GameStatus.done;
      });
      return;
    }

    // 이동한 위치에 음식이 있으면 먹고 점수 누적
    if (foodsMap.contains(_pacmanPos)) {
      _score++;
      foodsMap.remove(_pacmanPos);
    }

    // 입을 열고닫아야 살아있는 것처럼 보이지
    _pacmanMouseOpened = !_pacmanMouseOpened;

    // 모든 음식을 먹으면 승리한다.
    if (foodsMap.length == 0) {
      _status = GameStatus.done;
      _isWon = true;
      _pacmanMouseOpened = true;
      _timer!.cancel();
    }
    setState(() {});
  }

  void moveMonster() {
    List<int> nextOptions = [];

    int backPos = _monsterPos;
    int nextPos = _monsterPos;

    // 모든 방향이 막혀있다면 뒷걸음해야 한다.
    if (_monsterDirection == UnitDirection.up) {
      backPos = _monsterPos + countInRows;
    } else if (_monsterDirection == UnitDirection.down) {
      backPos = _monsterPos - countInRows;
    } else if (_monsterDirection == UnitDirection.left) {
      backPos = _monsterPos + 1;
    } else if (_monsterDirection == UnitDirection.right) {
      backPos = _monsterPos - 1;
    }

    // 열린 방향들을 찾아서 배열에 담아둔다.
    if (!wallsMap.contains(_monsterPos + countInRows)) {
      // down
      nextOptions.add(_monsterPos + countInRows);
    }
    if (!wallsMap.contains(_monsterPos - countInRows)) {
      // up
      nextOptions.add(_monsterPos - countInRows);
    }
    if (!wallsMap.contains(_monsterPos + 1)) {
      // right
      nextOptions.add(_monsterPos + 1);
    }
    if (!wallsMap.contains(_monsterPos - 1)) {
      // left
      nextOptions.add(_monsterPos - 1);
    }

    // 다음 위치를 랜덤하게 선택한다.
    // 단, 뒷걸음질은 확률을 낮추기 위해 연속으로 n회 나타나면 인정한다.
    for (var i = 0; i < 5; i++) {
      nextPos = nextOptions[Random().nextInt(nextOptions.length)];
      if (nextPos != backPos) break;
    }

    if (_monsterPos - countInRows == nextPos ) {
      _monsterDirection = UnitDirection.up;
    } else if (_monsterPos + countInRows == nextPos ) {
      _monsterDirection = UnitDirection.down;
    } else if (_monsterPos +1 == nextPos) {
      _monsterDirection = UnitDirection.right;
    } else if (_monsterPos  - 1 == nextPos) {
      _monsterDirection = UnitDirection.left;
    }
    _monsterPos = nextPos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: Column(
        children: [
          Stack(
            // fit: StackFit.expand,
            children: [
              GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  if (details.delta.dy > 0) {
                    print('Dragged Down');
                    _pacmanDirection = UnitDirection.down;
                  } else if (details.delta.dy < 0) {
                    print('Dragged Up');
                    _pacmanDirection = UnitDirection.up;
                  }
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  if (details.delta.dx > 0) {
                    print('Dragged right');
                    _pacmanDirection = UnitDirection.right;
                  } else if (details.delta.dx < 0) {
                    print('Dragged left');
                    _pacmanDirection = UnitDirection.left;
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: countTotal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: countInRows,
                    ),
                    itemBuilder: (_, index) {
                      if (wallsMap.contains(index)) {
                        return BuildWall();
                      } else if (_pacmanPos == index) {
                        return BuildPacman(direction: _pacmanDirection, mouseOpened: _pacmanMouseOpened);
                      } else if (_monsterPos == index) {
                        return BuildMonster();
                      } else if (foodsMap.contains(index)) {
                        return BuildFood();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              if (_status == GameStatus.waiting) BuildStartMessage(),
              if (_status == GameStatus.paused) BuildPausedMessage(),
              if (_status == GameStatus.done) BuildGameoverMessage(isWon: _isWon),
            ],
          ),
          Expanded(
            child: Container(
              color: AppStyle.bgColor,
              child: Row(
                children: [
                  Expanded(
                    child: BuildScoreBox(score: _score),
                  ),
                  Expanded(
                    child: BuildControllBox(
                      status: _status,
                      elapsedSeconds: _elapsedSeconds,
                      controllGame: _controllGame,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildStartMessage extends StatelessWidget {
  const BuildStartMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        child: Container(
          alignment: Alignment.center,
          color: Colors.black.withOpacity(.8),
          child: BlinkWidget(
            child: Text(
              'PRESS START',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 5.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildPausedMessage extends StatelessWidget {
  const BuildPausedMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        child: Container(
          alignment: Alignment.center,
          color: Colors.black.withOpacity(.8),
          child: Text(
            'PAUSED',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 5.0,
            ),
          ),
        ),
      ),
    );
  }
}

class BuildGameoverMessage extends StatelessWidget {
  const BuildGameoverMessage({Key? key, required this.isWon}) : super(key: key);

  final bool isWon;

  @override
  Widget build(BuildContext context) {
    Color? color = isWon ? Colors.yellow : Colors.grey[500];
    IconData icon = isWon ? Icons.thumb_up : Icons.thumb_down;
    String message = isWon ? 'You Won!' : 'You loose';

    return Positioned.fill(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        child: Container(
          alignment: Alignment.center,
          color: Colors.black.withOpacity(.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 36),
              SizedBox(width: 8),
              Text(
                message,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 5.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
