/// 입력한 시간을 문자열로 변환 => 01:23:55
String timeFormatter(
    {int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0}) {
  int time = hours * 60 * 60 * 1000 +
      minutes * 60 * 1000 +
      seconds * 1000 +
      milliseconds;
  Duration duration = Duration(milliseconds: time);

  return [duration.inHours, duration.inMinutes, duration.inSeconds]
      .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
      .join(':');
}
