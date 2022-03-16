import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  const BuildButton({Key? key, required this.onPresssed, required this.text}) : super(key: key);
  final String text;
  final VoidCallback onPresssed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: OutlinedButton(
          onPressed: onPresssed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
            backgroundColor: Colors.yellow,
            minimumSize: Size(170, 30),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.black87, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
