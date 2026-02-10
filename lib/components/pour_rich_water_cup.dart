import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PourRichWaterCup extends StatelessWidget {
  final int waterAmount;
  final int maxAmount;
  const PourRichWaterCup({
    super.key,
    required this.waterAmount,
    this.maxAmount = 1000,
  });
  @override
  Widget build(BuildContext context) {
    final waterLevel = (waterAmount / maxAmount).clamp(0.0, 1.0);
    return Center(
      child: SizedBox(
        width: 180.w,
        height: 220.h,
        child: CustomPaint(painter: WaterCupPainter(waterLevel: waterLevel)),
      ),
    );
  }
}

class WaterCupPainter extends CustomPainter {
  final double waterLevel;
  WaterCupPainter({required this.waterLevel});
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final topWidth = size.width * 0.7;
    final bottomWidth = size.width * 0.5;
    final cupHeight = size.height * 0.85;
    final topY = size.height * 0.08;
    final bottomY = topY + cupHeight;
    final bottomCornerRadius = 20.0;
    final rimHeight = 8.0;
    final rimPath = Path();
    rimPath.moveTo(centerX - topWidth / 2 - 4, topY);
    rimPath.lineTo(centerX + topWidth / 2 + 4, topY);
    rimPath.lineTo(centerX + topWidth / 2, topY + rimHeight);
    rimPath.lineTo(centerX - topWidth / 2, topY + rimHeight);
    rimPath.close();
    final rimPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
          ).createShader(
            Rect.fromLTWH(
              centerX - topWidth / 2 - 4,
              topY,
              topWidth + 8,
              rimHeight,
            ),
          );
    canvas.drawPath(rimPath, rimPaint);
    final cupPath = Path();
    cupPath.moveTo(centerX - topWidth / 2, topY + rimHeight);
    cupPath.lineTo(centerX - bottomWidth / 2, bottomY - bottomCornerRadius);
    cupPath.quadraticBezierTo(
      centerX - bottomWidth / 2,
      bottomY,
      centerX - bottomWidth / 2 + bottomCornerRadius,
      bottomY,
    );
    cupPath.lineTo(centerX + bottomWidth / 2 - bottomCornerRadius, bottomY);
    cupPath.quadraticBezierTo(
      centerX + bottomWidth / 2,
      bottomY,
      centerX + bottomWidth / 2,
      bottomY - bottomCornerRadius,
    );
    cupPath.lineTo(centerX + topWidth / 2, topY + rimHeight);
    cupPath.close();
    final cupBgPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFF5F5F5).withOpacity(0.3),
              Color(0xFFFFFFFF).withOpacity(0.5),
              Color(0xFFF0F0F0).withOpacity(0.3),
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(
            Rect.fromLTWH(centerX - topWidth / 2, topY, topWidth, cupHeight),
          );
    canvas.drawPath(cupPath, cupBgPaint);
    if (waterLevel > 0) {
      final waterHeight = cupHeight * waterLevel;
      final waterTop = bottomY - waterHeight;
      final waterTopWidth =
          topWidth -
          (topWidth - bottomWidth) *
              ((waterTop - topY - rimHeight) / cupHeight);
      final waterPath = Path();
      waterPath.moveTo(centerX - waterTopWidth / 2, waterTop);
      waterPath.lineTo(centerX + waterTopWidth / 2, waterTop);
      waterPath.lineTo(centerX + bottomWidth / 2, bottomY - bottomCornerRadius);
      waterPath.quadraticBezierTo(
        centerX + bottomWidth / 2,
        bottomY,
        centerX + bottomWidth / 2 - bottomCornerRadius,
        bottomY,
      );
      waterPath.lineTo(centerX - bottomWidth / 2 + bottomCornerRadius, bottomY);
      waterPath.quadraticBezierTo(
        centerX - bottomWidth / 2,
        bottomY,
        centerX - bottomWidth / 2,
        bottomY - bottomCornerRadius,
      );
      waterPath.lineTo(centerX - waterTopWidth / 2, waterTop);
      waterPath.close();
      final waterPaint = Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF81D4FA), Color(0xFFB3E5FC), Color(0xFF80DEEA)],
              stops: [0.0, 0.5, 1.0],
            ).createShader(
              Rect.fromLTWH(
                centerX - topWidth / 2,
                waterTop,
                topWidth,
                waterHeight,
              ),
            );
      canvas.drawPath(waterPath, waterPaint);
      final surfaceHighlight = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawLine(
        Offset(centerX - waterTopWidth / 2 + 5, waterTop + 1),
        Offset(centerX + waterTopWidth / 2 - 5, waterTop + 1),
        surfaceHighlight,
      );
    }
    final borderPaint = Paint()
      ..color = Color(0xFF424242)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(cupPath, borderPaint);
    final rimBorderPaint = Paint()
      ..color = Color(0xFF616161)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(rimPath, rimBorderPaint);
    final highlightPath = Path();
    highlightPath.moveTo(centerX - topWidth / 2 + 8, topY + rimHeight + 15);
    highlightPath.quadraticBezierTo(
      centerX - topWidth / 2 + 12,
      topY + cupHeight * 0.4,
      centerX - bottomWidth / 2 + 8,
      bottomY - 40,
    );
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(WaterCupPainter oldDelegate) =>
      waterLevel != oldDelegate.waterLevel;
}
