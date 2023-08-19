import 'package:flutter/material.dart';

class KeyBoardTap extends StatelessWidget {
  final Function(RawKeyEvent)? onKey;
  final FocusNode focusNode;
  final Widget child;
  const KeyBoardTap(
      {super.key, this.onKey, required this.child, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      onKey: onKey,
      child: child,
    );
  }
}
