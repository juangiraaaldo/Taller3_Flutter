import 'package:flutter/material.dart';

class WarmGradientBackground extends StatelessWidget {
  const WarmGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFCFC),
            Color(0xFFFFF6F2),
            Color(0xFFFFF2F5),
            Color(0xFFFFF0F7),
          ],
          stops: [0, 0.35, 0.7, 1],
        ),
      ),
      child: child,
    );
  }
}
