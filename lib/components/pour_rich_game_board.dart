import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pour_rich/utils/colors.dart';

class PourRichGameBoard extends StatelessWidget {
  final int currentPosition;
  final int animatingPosition;
  final bool isAnimating;
  final int highlightedTile;
  const PourRichGameBoard({
    super.key,
    required this.currentPosition,
    this.animatingPosition = 1,
    this.isAnimating = false,
    this.highlightedTile = 0,
  });
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GameBoardPainter(
        currentPosition: currentPosition,
        animatingPosition: animatingPosition,
        isAnimating: isAnimating,
        highlightedTile: highlightedTile,
      ),
    );
  }
}

class GameBoardPainter extends CustomPainter {
  final int currentPosition;
  final int animatingPosition;
  final bool isAnimating;
  final int highlightedTile;
  GameBoardPainter({
    required this.currentPosition,
    this.animatingPosition = 1,
    this.isAnimating = false,
    this.highlightedTile = 0,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final tiles = _getTiles();
    final tileSize = 50.0.w;
    final positions = _calculateTilePositions(size, tiles.length, tileSize);
    for (int i = 0; i < tiles.length; i++) {
      final isHighlighted = highlightedTile == (i + 1);
      _drawTile(
        canvas,
        positions[i],
        tileSize,
        tiles[i],
        i + 1 == currentPosition && !isAnimating,
        isHighlighted,
      );
    }
    if (isAnimating &&
        animatingPosition >= 1 &&
        animatingPosition <= tiles.length) {
      final animPos = positions[animatingPosition - 1];
      final rect = Rect.fromLTWH(animPos.dx, animPos.dy, tileSize, tileSize);
      _drawPlayerToken(canvas, rect);
    }
  }

  List<Map<String, dynamic>> _getTiles() {
    return [
      {'type': 'start', 'number': 1},
      {'type': 'normal', 'number': 2},
      {'type': 'question', 'number': 3},
      {'type': 'normal', 'number': 4},
      {'type': 'empty', 'number': 5},
      {'type': 'forward', 'number': 6},
      {'type': 'question', 'number': 7},
      {'type': 'empty', 'number': 8},
      {'type': 'question', 'number': 9},
      {'type': 'normal', 'number': 10},
      {'type': 'empty', 'number': 11},
      {'type': 'normal', 'number': 12},
      {'type': 'normal', 'number': 13},
      {'type': 'normal', 'number': 14},
      {'type': 'normal', 'number': 15},
      {'type': 'normal', 'number': 16},
      {'type': 'normal', 'number': 17},
      {'type': 'forward', 'number': 18},
      {'type': 'empty', 'number': 19},
      {'type': 'forward', 'number': 20},
      {'type': 'forward', 'number': 21},
      {'type': 'forward', 'number': 22},
      {'type': 'question', 'number': 23},
      {'type': 'question', 'number': 24},
      {'type': 'finish', 'number': 25},
    ];
  }

  List<Offset> _calculateTilePositions(Size size, int count, double tileSize) {
    final positions = <Offset>[];
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radiusX = size.width * 0.38;
    final radiusY = size.height * 0.42;
    final totalAngle = (320 / 360) * 2 * pi;
    final startAngle = -pi / 2 + (2 * pi - totalAngle) / 2;
    for (int i = 0; i < count; i++) {
      final angle = startAngle + (i / (count - 1)) * totalAngle;
      final x = centerX + radiusX * cos(angle) - tileSize / 2;
      final y = centerY + radiusY * sin(angle) - tileSize / 2;
      positions.add(Offset(x, y));
    }
    return positions;
  }

  void _drawTile(
    Canvas canvas,
    Offset position,
    double size,
    Map<String, dynamic> tile,
    bool isCurrent,
    bool isHighlighted,
  ) {
    final rect = Rect.fromLTWH(position.dx, position.dy, size, size);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(8.r));
    final paint = Paint()..style = PaintingStyle.fill;
    Color bgColor;
    if (isCurrent) {
      bgColor = Color(0xFFFFF9C4);
    } else if (isHighlighted) {
      bgColor = Color(0xFFFFD54F);
    } else {
      switch (tile['type']) {
        case 'start':
        case 'finish':
          bgColor = Color(0xFFE8F5E9);
          break;
        case 'question':
          bgColor = Color(0xFFFFF3E0);
          break;
        case 'forward':
          bgColor = Color(0xFFFFF9C4);
          break;
        case 'empty':
          bgColor = Color(0xFFF5F5F5);
          break;
        default:
          bgColor = Colors.white;
      }
    }
    paint.color = bgColor;
    canvas.drawRRect(rRect, paint);
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.shift(Offset(0, 2)), Radius.circular(8.r)),
      shadowPaint,
    );
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isCurrent ? 4.0 : (isHighlighted ? 2.5 : 1.5)
      ..color = isCurrent
          ? Color(0xFFFF6F00)
          : (isHighlighted
                ? Color(0xFFFFD54F)
                : PourRichColors.textSecondary.withOpacity(0.2));
    canvas.drawRRect(rRect, borderPaint);
    if (isCurrent) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = Color(0xFFFF6F00).withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawRRect(rRect, glowPaint);
    }
    final numberSpan = TextSpan(
      text: tile['number'].toString(),
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: PourRichColors.textSecondary,
      ),
    );
    final numberPainter = TextPainter(
      text: numberSpan,
      textDirection: TextDirection.ltr,
    );
    numberPainter.layout();
    numberPainter.paint(
      canvas,
      Offset(
        rect.center.dx - numberPainter.width / 2,
        rect.bottom - numberPainter.height - 4,
      ),
    );
    if (tile['type'] == 'question') {
      _drawEmoji(canvas, rect, '❓', size * 0.48);
    } else if (tile['type'] == 'forward') {
      _drawEmoji(canvas, rect, '💰', size * 0.48);
    } else if (tile['type'] == 'empty') {
      _drawEmoji(canvas, rect, '🏢', size * 0.45);
    } else if (tile['type'] == 'start') {
      _drawEmoji(canvas, rect, '🏠', size * 0.48);
    } else if (tile['type'] == 'finish') {
      _drawEmoji(canvas, rect, '🏁', size * 0.48);
    }
    if (isCurrent && !isAnimating) {
      _drawPlayerToken(canvas, rect);
    }
  }

  void _drawEmoji(Canvas canvas, Rect rect, String emoji, double size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: size),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(rect.center.dx - textPainter.width / 2, rect.top + 6),
    );
  }

  void _drawPlayerToken(Canvas canvas, Rect tileRect) {
    final tokenPaint = Paint()
      ..color = Color(0xFFFF6F00)
      ..style = PaintingStyle.fill;
    final tokenRadius = tileRect.width * 0.18;
    final tokenCenter = Offset(
      tileRect.right - tokenRadius - 4,
      tileRect.top + tokenRadius + 4,
    );
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(tokenCenter.translate(0, 1), tokenRadius, shadowPaint);
    canvas.drawCircle(tokenCenter, tokenRadius, tokenPaint);
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(tokenCenter, tokenRadius, borderPaint);
    final textPainter = TextPainter(
      text: TextSpan(
        text: '🎯',
        style: TextStyle(fontSize: tokenRadius * 1.5),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        tokenCenter.dx - textPainter.width / 2,
        tokenCenter.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(GameBoardPainter oldDelegate) =>
      currentPosition != oldDelegate.currentPosition ||
      animatingPosition != oldDelegate.animatingPosition ||
      isAnimating != oldDelegate.isAnimating ||
      highlightedTile != oldDelegate.highlightedTile;
}
