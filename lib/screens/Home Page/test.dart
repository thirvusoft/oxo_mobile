import 'dart:math';

import 'package:flutter/material.dart';

class ShakingHiEmoji extends StatefulWidget {
  @override
  _ShakingHiEmojiState createState() => _ShakingHiEmojiState();
}

class _ShakingHiEmojiState extends State<ShakingHiEmoji> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      setState(() {
        _offset = Random().nextDouble() * 10 - 5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 50),
      transform: Matrix4.translationValues(_offset, 0.0, 0.0),
      child: Text(
        ' 👋',
        style: TextStyle(fontSize: 48),
      ),
    );
  }
}
