import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/fondo.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 238,
      child: CustomPaint(
        painter: _CelebrationPainter(),
        child: const Center(
          child: Icon(Icons.celebration_rounded, size: 46, color: Colors.white),
        ),
      ),
    );
  }
}

class _CelebrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 12);
    final ground = Paint()..color = const Color(0x26FFFFFF);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height - 8),
        width: size.width * .75,
        height: 28,
      ),
      ground,
    );

    final left = Paint()..color = const Color(0xFFF63B76);
    final right = Paint()..color = const Color(0xFFFF638B);
    final skin = Paint()..color = const Color(0xFFD68B80);
    final dark = Paint()..color = AppColors.navy;
    final blue = Paint()..color = const Color(0xFFB9D4E8);

    canvas.drawCircle(Offset(center.dx - 58, center.dy - 65), 21, skin);
    canvas.drawCircle(Offset(center.dx + 48, center.dy - 72), 21, skin);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 58, center.dy - 84),
        width: 54,
        height: 34,
      ),
      dark,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 48, center.dy - 89),
        width: 50,
        height: 31,
      ),
      dark,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx - 54, center.dy - 25),
          width: 60,
          height: 82,
        ),
        const Radius.circular(18),
      ),
      left,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + 48, center.dy - 20),
          width: 65,
          height: 90,
        ),
        const Radius.circular(18),
      ),
      right,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx + 48, center.dy + 46),
        width: 58,
        height: 62,
      ),
      blue,
    );
    canvas.drawLine(
      Offset(center.dx - 32, center.dy + 12),
      Offset(center.dx - 40, center.dy + 80),
      dark..strokeWidth = 14,
    );
    canvas.drawLine(
      Offset(center.dx - 4, center.dy + 10),
      Offset(center.dx - 10, center.dy + 82),
      dark..strokeWidth = 14,
    );
    canvas.drawLine(
      Offset(center.dx + 37, center.dy + 74),
      Offset(center.dx + 28, center.dy + 110),
      dark..strokeWidth = 14,
    );
    canvas.drawLine(
      Offset(center.dx + 65, center.dy + 74),
      Offset(center.dx + 69, center.dy + 110),
      dark..strokeWidth = 14,
    );
    canvas.drawLine(
      Offset(center.dx - 34, center.dy - 43),
      Offset(center.dx + 1, center.dy - 98),
      left..strokeWidth = 12,
    );
    canvas.drawLine(
      Offset(center.dx + 13, center.dy - 97),
      Offset(center.dx + 31, center.dy - 48),
      right..strokeWidth = 12,
    );
    canvas.drawCircle(Offset(center.dx + 1, center.dy - 105), 8, skin);
    canvas.drawCircle(Offset(center.dx + 4, center.dy - 99), 8, skin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
