import 'dart:async';
import 'package:flutter/material.dart';

class LoopingTypeWriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle style;
  final Duration typingDuration;
  final Duration pauseDuration;

  const LoopingTypeWriterText({
    Key? key,
    required this.texts,
    required this.style,
    this.typingDuration = const Duration(milliseconds: 100),
    this.pauseDuration = const Duration(milliseconds: 3000),
  }) : super(key: key);

  @override
  State<LoopingTypeWriterText> createState() => _LoopingTypeWriterTextState();
}

class _LoopingTypeWriterTextState extends State<LoopingTypeWriterText> {
  int _textIndex = 0;
  int _charIndex = 0;
  String _displayedText = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.typingDuration, (timer) {
      if (!mounted || widget.texts.isEmpty) return;

      final currentFullText = widget.texts[_textIndex];
      if (_charIndex < currentFullText.length) {
        setState(() {
          _displayedText += currentFullText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
        Future.delayed(widget.pauseDuration, () {
          if (!mounted) return;
          setState(() {
            _textIndex = (_textIndex + 1) % widget.texts.length;
            _charIndex = 0;
            _displayedText = '';
          });
          _startTyping();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
      textAlign: TextAlign.start,
    );
  }
}
